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

cli = PlaybookCLI(["ansible-playbook", str(playbook_path)])
cli.parse()

context.CLIARGS = context.CLIARGS.copy()
context.CLIARGS["connection"] = "local"
context.CLIARGS["verbosity"] = 0

# ---- Plugin loader (REQUIRED) ----
init_plugin_loader()

# Define playbook stuff
loader = DataLoader()

inventory = InventoryManager(loader=loader, sources=["localhost,"])
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
