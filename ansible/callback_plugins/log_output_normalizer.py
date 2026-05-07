from ansible.plugins.callback import CallbackBase
import json
import urllib.request

DOCUMENTATION = """
    name: log_output_normalizer
    type: stdout
    short_description: Cleaner log outputs
    description:
        - Custom log outputs
"""


class CallbackModule(CallbackBase):
    CALLBACK_VERSION = 2.0
    CALLBACK_TYPE = "stdout"
    CALLBACK_NAME = "log_output_normalizer"

    RED = "\033[31m"
    GREEN = "\033[32m"
    YELLOW = "\033[33m"
    RESET = "\033[0m"

    def v2_runner_on_ok(self, result):
        host = result._host.get_name()
        msg = result._result.get("msg", "")

        if msg:
            self._display.display(f"{self.GREEN}{msg}{self.RESET}")
        else:
            self._display.display(f"{self.GREEN}{host}: OK{self.RESET}")

    def v2_runner_on_failed(self, result, ignore_errors=False):
        host = result._host.get_name()
        self._display.display(f"{self.RED}{host}: FAILED{self.RESET}")

    def v2_runner_on_skipped(self, result):
        host = result._host.get_name()
        self._display.display(f"{self.YELLOW}{host}: SKIPPED{self.RESET}")
