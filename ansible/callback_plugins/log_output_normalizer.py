from ansible.plugins.callback import CallbackBase
from ansible import constants as C
import json
import urllib.request

import logging

logging.basicConfig(format="%(message)s", level=logging.INFO)

log = logging.getLogger("ansible")
log.info("hello world")

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

    def v2_playbook_on_start(self, playbook):
        # self._display.display(
        #    f"Starting Playbook.... | green is: {C.COLOR_OK}, red is: {C.COLOR_ERROR}",
        #    color=C.COLOR_WARN,
        # )

        log = logging.getLogger("ansible")
        log.info("Starting Playbook.....")

    def v2_runner_on_ok(self, result):
        host = result._host.get_name()
        msg = result._result.get("msg", "")

        if msg:
            self._display.display(f"{msg}", color=C.COLOR_OK)
        else:
            self._display.display(f"{host}: OK", color=C.COLOR_CHANGED)

    def v2_runner_on_failed(self, result, ignore_errors=False):
        host = result._host.get_name()
        self._display.display(f"{host}: FAILED", color=C.COLOR_ERROR)

    def v2_runner_on_skipped(self, result):
        host = result._host.get_name()
        self._display.display(f"{host}: SKIPPED", color=C.COLOR_ERROR)
