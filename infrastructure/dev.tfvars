runner_name = "githubrunner"
repository = "https://github.com/aradman/mlops-v2"
vnet_cidr = "10.0.0.0/16"
private_endpoints_subnet = {
  name           = "sub-private-endpoints"
  address_prefix = "10.0.0.0/26"
  network_security_group = {
    name = "pe-nsg"
    rules = []
  }
  delegation = []
}

bastion_subnet = {
  name           = "AzureBastionSubnet"
  address_prefix = "10.0.0.64/26"
  network_security_group = {
    name = "bastion-nsg"
    rules = [
      # Inbound Rules
      {
        name                         = "Allow_Internet_Inbound"
        priority                     = 100
        direction                    = "Inbound"
        access                       = "Allow"
        protocol                     = "*"
        source_address_prefix        = "Internet"
        source_port_range            = "*"
        destination_address_prefix   = "*"
        destination_port_ranges      = ["443"]               
        description                  = "Allow inbound from Internet service tag"
      },
      {
        name                         = "Allow_GatewayManager_Control_Plane_Inbound"
        priority                     = 110
        direction                    = "Inbound"
        access                       = "Allow"
        protocol                     = "*"
        source_address_prefix        = "GatewayManager"
        source_port_range            = "*"
        destination_address_prefix   = "*"
        destination_port_ranges      = ["443"]               
        description                  = "Allow control plane traffic from GatewayManager service tag" 
      },
      {
        name                         = "Allow_VirtualNetwork_Data_Plane_Inbound"
        priority                     = 120
        direction                    = "Inbound"
        access                       = "Allow"
        protocol                     = "*"
        source_address_prefix        = "VirtualNetwork"
        source_port_range            = "*"
        destination_address_prefix   = "*"
        destination_port_ranges      = ["8080", "5701"]        
        description                  = "Allow data plane traffic from VirtualNetwork service tag" 
      },
      {
        name                         = "Allow_AzureLoadBalancer_Inbound"
        priority                     = 130
        direction                    = "Inbound"
        access                       = "Allow"
        protocol                     = "*"
        source_address_prefix        = "AzureLoadBalancer"
        source_port_range            = "*"
        destination_address_prefix   = "*"
        destination_port_ranges      = ["443"]        
        description                  = "Allow traffic from AzureLoadBalancer service tag" 
      },
      # Outbound Rules
      {
        name                         = "Allow_VirtualNetwork_SSH_RDP_Outbound"
        priority                     = 110
        direction                    = "Outbound"
        access                       = "Allow"
        protocol                     = "*"
        source_address_prefix        = "*"
        source_port_range            = "*"
        destination_address_prefix   = "VirtualNetwork"
        destination_port_ranges      = ["3389", "22"]        
        description                  = "Allow rdp and ssh traffic to VirtualNetwork service tag" 
      },
      {
        name                         = "Allow_VirtualNetwork_Data_Plane_Outbound"
        priority                     = 120
        direction                    = "Outbound"
        access                       = "Allow"
        protocol                     = "*"
        source_address_prefix        = "*"
        source_port_range            = "*"
        destination_address_prefix   = "VirtualNetwork"
        destination_port_ranges      = ["8080", "5701"]
        description                  = "Allow data plane traffic to VirtualNetwork service tag" 
      },
      {
        name                         = "Allow_AzureCloud_Outbound"
        priority                     = 130
        direction                    = "Outbound"
        access                       = "Allow"
        protocol                     = "*"
        source_address_prefix        = "*"
        source_port_range            = "*"      
        destination_address_prefix   = "AzureCloud"
        destination_port_ranges      = ["443"]
        description                  = "Allow traffic to AzureCloud service tag" 
      },
      {
        name                         = "Allow_Internet_Outbound"
        priority                     = 140
        direction                    = "Outbound"
        access                       = "Allow"
        protocol                     = "*"
        source_address_prefix        = "*"
        source_port_range            = "*"
        destination_address_prefix   = "Internet"
        destination_port_ranges      = ["80"]
        description                  = "Allow traffic to Internet service tag" 
      }
    ]
  }
  delegation = []
}

management_subnet = {
  name           = "sub-management"
  address_prefix = "10.0.0.128/27"
  network_security_group = {
    name = "management-nsg"
    rules = []
  }
  delegation = []
}

runner_subnet = {
  name           = "sub-runner"
  address_prefix = "10.0.0.160/27"
  network_security_group = {
    name = "runner-nsg"
    rules = []
  }
  delegation = []
}