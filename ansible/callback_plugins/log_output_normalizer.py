from ansible.plugins.callback import CallbackBase
from ansible import constants as C
import json
import urllib.request

import logging

logging.basicConfig(filename="dotfiles.log", format="%(message)s", level=logging.INFO)


DOCUMENTATION = """
    name: log_output_normalizer
    type: stdout
    short_description: Cleaner log outputs
    description:
        - Custom log outputs
"""


class AnsibleFormatter(logging.Formatter):
    """
    Define a custom formatter
    """

    def format(self, record):
        level = record.levelname
        msg = record.getMessage()
        return f"MyFormat - {level}: {msg}"


# Attach Custom Format to a stream handler
custom_stream_handler = logging.StreamHandler()
custom_stream_handler.setFormatter(AnsibleFormatter())

# Attach custom format to a file handler
custom_file_handler = logging.FileHandler("dotfiles.log")
custom_file_handler.setFormatter(AnsibleFormatter())

# Assign Custom Format Handler to ansible logger
log = logging.getLogger("custom_ansible")
log.handlers = [custom_stream_handler, custom_file_handler]

# log.info("Log Format Created")


class CallbackModule(CallbackBase):
    CALLBACK_VERSION = 2.0
    CALLBACK_TYPE = "stdout"
    CALLBACK_NAME = "log_output_normalizer"

    RED = "\033[31m"
    GREEN = "\033[32m"
    YELLOW = "\033[33m"
    RESET = "\033[0m"

    def __init__(self):
        """ """
        self._play = None
        self._last_task_banner = None
        self._last_task_name = None
        self._task_type_cache = {}
        super(CallbackModule, self).__init__()

        # log.propagate = False

        mylog = logging.getLogger("custom_ansible")

        mylog.info("Testing log")

    def v2_playbook_on_start(self, playbook):
        # self._display.display(
        #    f"Starting Playbook.... | green is: {C.COLOR_OK}, red is: {C.COLOR_ERROR}",
        #    color=C.COLOR_WARN,
        # )

        mylog = logging.getLogger("custom_ansible")
        mylog.info("Starting Playbook.....")

    def v2_runner_on_ok(self, result):
        host = result._host.get_name()
        msg = result._result.get("msg", "")
        mylog = logging.getLogger("custom_ansible")

        if msg:
            # self._display.display(f"{msg}", color=C.COLOR_OK)
            mylog.info(f"{msg}?")
        else:
            # self._display.display(f"{host}: OK", color=C.COLOR_CHANGED)
            mylog.info(f"{host}: OK")

    def v2_runner_on_failed(self, result, ignore_errors=False):
        host = result._host.get_name()
        # self._display.display(f"{host}: FAILED", color=C.COLOR_ERROR)

        mylog = logging.getLogger("custom_ansible")
        mylog.info(f"{host}: FAILED")

    def v2_runner_on_skipped(self, result):
        host = result._host.get_name()
        # self._display.display(f"{host}: SKIPPED", color=C.COLOR_ERROR)

        mylog = logging.getLogger("custom_ansible")
        mylog.info(f"{host}: SKIPPED")
