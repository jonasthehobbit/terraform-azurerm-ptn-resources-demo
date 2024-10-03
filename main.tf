data "terraform_remote_state" "workload" {
  backend = "remote"
  config = {
    organization = "MMUDemo"
    workspaces = {
      name = "terraform-azurerm-ptn-workload-demo"
    }
  }
}
module "naming" {
  source  = "Azure/naming/azurerm"
  version = "0.4.1"
  suffix  = ["mmu", "demo"]
}
module "testvm" {
 source = "Azure/avm-res-compute-virtualmachine/azurerm"
  version = "0.16.0"

  location            = data.terraform_remote_state.workload.outputs.resource_group_location
  resource_group_name = data.terraform_remote_state.workload.outputs.resource_group_name
  name                = module.naming.virtual_machine.name_unique
  zone                = 1

  network_interfaces = {
    network_interface_1 = {
      name = module.naming.network_interface.name_unique
      ip_configurations = {
        ip_configuration_1 = {
          name                          = "${module.naming.network_interface.name_unique}-ipconfig1"
          private_ip_subnet_resource_id = data.terraform_remote_state.workload.outputs.subnet["wkld_data"]
        }
      }
    }
  }
}