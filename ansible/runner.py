from pprint import pprint
import argparse
from ansible.module_utils.common.collections import ImmutableDict

from pathlib import Path
from ansible.executor.playbook_executor import PlaybookExecutor
from ansible.inventory.manager import InventoryManager
from ansible.parsing.dataloader import DataLoader
from ansible.vars.manager import VariableManager
from ansible.utils.display import Display
from ansible.plugins.loader import init_plugin_loader
from ansible.cli.playbook import PlaybookCLI

from ansible import context
from ansible.module_utils.ansible_release import __version__ as ansible_version

# Custom arguments to get custom playbook url
parser = argparse.ArgumentParser(
    prog="Ansible Pull Runner",
    description="Runs ansible pull with python API instead of CLI",
    epilog="I dont know what this section is for",
)

# Define an argument for the filename
parser.add_argument("filename")

# Retrieve the args
args = parser.parse_args()

# Retrieve the playbook filename
filename = args.filename

playbook_path = Path(__file__).parent.joinpath("playbooks", filename)

cli = PlaybookCLI(
    ["ansible-playbook", str(playbook_path), f'-e "ansible_version={ansible_version}"']
)
cli.parse()

# context.CLIARGS = context.CLIARGS.copy()
# context.CLIARGS["connection"] = "local"
# context.CLIARGS["verbosity"] = 0

cliargs = dict(context.CLIARGS)

cliargs["connection"] = "local"
cliargs["verbosity"] = 0

# print(type(ansible_version))
# pprint(ansible_version)
# print(type(cliargs["extra_vars"]))
#
# extra_vars = cliargs.get("extra_vars", tuple)
# extra_vars = cliargs.get("extra_vars") + (f"ansible_version={ansible_version}",)
# print(extra_vars)
#
# cliargs["extra_vars"] = (f"ansible_version={ansible_version}",)

context.CLIARGS = ImmutableDict(**cliargs)

# ---- Plugin loader (REQUIRED) ----
init_plugin_loader()

# Define playbook stuff
loader = DataLoader()

inventory = InventoryManager(loader=loader, sources=["localhost,"])


#     "ansible_version": {
#         "full": ansible_version,
#         "string": ansible_version,
#     }
# }

variable_manager = VariableManager(loader=loader, inventory=inventory)

passwords = {}


# Instantiate a playbook executor to get rid of excessive ansible print statements
executor = PlaybookExecutor(
    playbooks=[str(playbook_path)],
    inventory=inventory,
    variable_manager=variable_manager,
    loader=loader,
    passwords=passwords,
)

# Run the executor
executor.run()
