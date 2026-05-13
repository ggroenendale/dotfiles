from pprint import pprint, pformat
from typing import TYPE_CHECKING

from pathlib import Path
import os
import json
import urllib.request
import logging

from ansible.plugins.callback import CallbackBase
from ansible import constants as C
from ansible.executor.task_result import CallbackTaskResult
from ansible.playbook import Playbook, PlaybookInclude

BORDER_LENGTH = 70

DOCUMENTATION = """
    name: log_output_normalizer
    type: stdout
    short_description: Cleaner log outputs
    description:
        - Custom log outputs
    options:
        custom_log_path:
            description: Path to custom log
            env:
                - name: ANSIBLE_CUSTOM_LOG_PATH
            ini:
                - section: callback_log_output_normalizer
                  key: custom_log_path
"""


def style(text, fg=None, bg=None, bold=False) -> str:
    """
    Text color style

    :param text: The text to format
    :type text: str
    :param fg: The text foreground color in RGB
    :type fg: tuple
    :param bg: The text background color in RGB
    :type bg: tuple
    :param bold: Boolean to make the text normal or bold
    :type bold: bool
    :return: Return the formatted string
    :rtype: str
    """
    codes = []

    if bold:
        codes.append("1")

    if isinstance(fg, tuple):  # RGB
        codes.append(f"38;2;{fg[0]};{fg[1]};{fg[2]}")
    elif fg is not None:
        codes.append(str(fg))

    if isinstance(bg, tuple):
        codes.append(f"48;2;{bg[0]};{bg[1]};{bg[2]}")
    elif bg is not None:
        codes.append(str(bg))

    prefix = f"\x1b[{';'.join(codes)}m" if codes else ""
    suffix = "\x1b[0m"

    return f"{prefix}{text}{suffix}"


class AnsibleFormatter(logging.Formatter):
    """
    Define a custom formatter
    """

    def format(self, record):
        level = record.levelname
        msg = record.getMessage()
        return f"MyFormat - {level}: {msg}"


class CallbackModule(CallbackBase):
    CALLBACK_VERSION = 2.0
    CALLBACK_TYPE = "stdout"
    CALLBACK_NAME = "log_output_normalizer"

    RED = "\033[31m"
    GREEN = "\033[32m"
    YELLOW = "\033[33m"
    RESET = "\033[0m"

    def __init__(self):
        """
        Instantiate the Callback Module

        """

        super(CallbackModule, self).__init__()
        self.log_file = None

        self.playbook_name = None
        self.play_name = None

    def set_options(self, task_keys=None, var_options=None, direct=None):
        """
        Load options from configuration.

        :param task_keys:
        :param var_options:
        :param direct:
        """
        super(CallbackModule, self).set_options(
            task_keys=task_keys, var_options=var_options, direct=direct
        )
        self.log_file = self.get_option("custom_log_path")

    def _log(self, msg: str):
        """
        Custom function write to a log file with custom formatting

        :param msg: The string statement to print to the terminal or file
        :type msg: str
        """

        # Ensure directory exists
        log_file = Path(__file__).parent.parent.parent.joinpath("logs", self.log_file)
        os.makedirs(os.path.dirname(log_file), exist_ok=True)

        # Try to write to the log file stripping out the formatting
        with open(log_file, "a") as f:
            f.write(f"{msg}\n")

    def _log_to_term(self, msg: str):
        """
        Custom function to log to stdout with custom colors

        :param msg: The string statement to print to the terminal or file
        :type msg: str
        :param color: The color of the string for the terminal
        :type color: str
        """

        # Create the reset constant to undue any formatting
        reset = "\x1b[0m"

        # First write the log to the terminal so the statement shows regardless
        # file writing issues
        print(f"{msg} {reset}")

    def _insert_major_border(self, fg=None, bg=None):
        """
        Prints a border for readability
        """
        major_border = "=" * BORDER_LENGTH
        f_major_border = style(major_border, fg=fg, bg=bg)

        self._log_to_term(f_major_border)

        self._log(major_border)

    def _insert_minor_border(self, fg=None, bg=None):
        """
        Prints a border for readability
        """
        minor_border = "-" * BORDER_LENGTH
        f_minor_border = style(minor_border, fg=fg, bg=bg)

        self._log_to_term(f"  {f_minor_border}")

        self._log(f"  {minor_border}")

    def _handle_debug(self, result: CallbackTaskResult):
        """
        Handle debug statements

        :param result:
        :type result: CallbackTaskResult
        """
        # Try to retrieve the variable to debug
        var = result.task.args.get("var", "")

        # Setup pprint
        def left_indent(text, indent=' ' * 8):
            return ''.join([indent + l for l in text.splitlines(True)])

        if len(var) > 0:
            # Add a minor border first
            self._insert_minor_border(fg=(240, 128, 49))

            # Debug Header
            debug_header = f"    Debugging: {var}"
            f_debug_header = style(debug_header, fg=(240, 128, 49))

            # Format variable
            variable = left_indent(pformat(result._result.get(var,"")))
            f_variable = style(variable, fg=(240, 128, 49))

            # Debug full variables here
            self._log_to_term(f_debug_header)
            self._log(debug_header)
            self._insert_minor_border(fg=(240, 128, 49))
            self._log_to_term(f_variable)
            self._log(variable)
            self._insert_minor_border(fg=(240, 128, 49))

        elif var == "full":
            print("Debugging full dictionary")
            pprint(result.__dict__)
        else:
            # Sometimes I only use debug for msg prints.
            pass

    def v2_playbook_on_start(self, playbook: Playbook):
        """
        On playbook start this function fires off

        :param playbook: The playbook object
        """

        # Create and format the prefix
        prefix = "[PLAYBOOK START]"
        f_prefix = style(prefix, fg=(255, 255, 255), bg=(31, 39, 235))

        # Define a message to log
        msg = f": Starting Playbook - {playbook._file_name}"

        # Add a major border:
        self._insert_major_border()
        self._insert_major_border()

        # First log to terminal
        self._log_to_term(f"{f_prefix}{msg}")

        # Then log to file
        self._log(f"{prefix}{msg}")

    def v2_playbook_on_include(self, included_file: PlaybookInclude):
        """
        Print statements when files are included

        :param included_file:
        :type included_file: str
        """
        file_name = str(included_file._filename)
        prefix = "[INCLUDE TASKS]"
        f_prefix = style(prefix, fg=(255, 255, 255), bg=(204, 43, 224))

        # First log to terminal
        self._log_to_term(f"  {f_prefix} - {file_name}")

        # Then log to file
        self._log(f"  {prefix} - {file_name}")

    def v2_playbook_on_task_start(self, task, is_conditional):
        """
        Function to be able to write task info regardless of fail or success

        :param task:
        :type task: CallbackTaskResult
        :param is_conditional:
        :type is_conditional: bool
        """
        # First log to terminal
        # self._log_to_term(f"  {f_prefix}: {task_name}")

        # Then log to file
        # self._log(f"  {prefix} - {task_name}")
        pass

    def v2_runner_on_ok(self, result: CallbackTaskResult):
        """

        :param result:
        :type result: CallbackTaskResult
        """
        # Retrieve some values
        host = result._host.get_name()
        msg = result._result.get("msg", "")

        # Create a task output header
        prefix = "[TASK START]"
        f_prefix = style(prefix, fg=(255, 255, 255), bg=(204, 43, 224))
        task_name = result.task.get_name().strip()

        # First log to terminal
        self._log_to_term(f"  {f_prefix} --- {task_name} ---")
        # Then log to file
        self._log(f"  {prefix} --- {task_name} ---")

        # Add a minor border:
        self._insert_minor_border()
        # Create normal task info output
        prefix = "[TASK INFO]"
        f_prefix = style(prefix, fg=(255, 255, 255), bg=(31, 39, 235))

        # First log to terminal
        self._log_to_term(f"    {f_prefix}")

        # Then log to file
        self._log(f"    {prefix}")

        # If debugging variables, run debug function passing
        # in the result object
        if result.task.action == "ansible.builtin.debug":
            # Handle variable debug
            self._handle_debug(result=result)
            self._insert_minor_border()

        if msg:
            if isinstance(msg, list):
                # If msg is a list, loop through its contents and print
                for line in msg:
                    # Print each line
                    self._log_to_term(f"    {line}")
                    self._log(f"    {line}")
            else:
                # First log to terminal
                self._log_to_term(f"    {msg}")

                # Then log to file
                self._log(f"    {msg}")

        else:
            # First log to terminal
            self._log_to_term(f"    OK")

            # Then log to file
            self._log(f"    OK")

        # Create task end
        # Add a minor border:
        self._insert_minor_border()

    def v2_runner_on_skipped(self, result: CallbackTaskResult):
        """
        When a task is skipped we print nothing

        :param result: Type result object
        :type result: CallbackTaskResult
        """
        # host = result._host.get_name()
        # task_name = result.task.get_name().strip()
        #
        # prefix = "[TASK SKIPPED]"
        # f_prefix = style(prefix, fg=(255, 255, 255), bg=(137, 138, 145))
        #
        # # First log to terminal
        # self._log_to_term(f"  {f_prefix}: {task_name}")
        #
        # # Then log to file
        # self._log(f"  {prefix}: {task_name}")
        pass

    def v2_runner_on_failed(self, result: CallbackTaskResult, ignore_errors=False):
        """
        What to print on Task Failed

        :param result:
        :type result: CallbackTaskResult
        :param ignore_errors:
        :type ignore_errors: bool
        """
        host = result._host.get_name()
        task_name = result.task.get_name().strip()
        err_msg = result._result.get("msg", "")

        # Create a task output header
        prefix = "[TASK START]"
        f_prefix = style(prefix, fg=(255, 255, 255), bg=(204, 43, 224))
        task_name = result.task.get_name().strip()

        # First log to terminal
        self._log_to_term(f"  {f_prefix} --- {task_name} ---")
        # Then log to file
        self._log(f"  {prefix} --- {task_name} ---")

        prefix = "[TASK FAILED]"
        f_prefix = style(prefix, fg=(255, 255, 255), bg=(137, 138, 145))

        # First log to terminal
        self._log_to_term(f"  {f_prefix}: {task_name} - {err_msg}")

        # Then log to file
        self._log(f"  {prefix}: {task_name} - {err_msg}")

        # Debug full variables here
        # pprint(result.__dict__)
        self._insert_minor_border()
