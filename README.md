# AHB2APB Bridge IP Core Design and Verification
AHB-to-APB Bridge Verification using UVM Methodology.

The AHB to APB bridge is an AHB slave which works as an interface between the high speed AHB and the low performance APB buses. DUT is AHB-to-APB Bridge which is AHB Slave and APB Master. We will use 1 AHB Master and 4 APB Slaves. Need to verify whether the data sent by the AHB Master has reached the APB slave and vice versa.

Bridge will do the following: Latches address and holds it valid throughout the transfer. Decodes address and generates peripheral select. Only one select signal can be active during a transfer. Drives data onto the APB for a write transfer. Drives APB data onto system bus for a read transfer. Generates PENABLE for the transfer.

# Bus Interconnection:
![Screenshot 2024-09-16 220339](https://github.com/user-attachments/assets/5ac84699-e409-4d0c-8176-e04c83f678b6)

# Block Diagram of Bridge module:
![Screenshot 2024-09-16 220411](https://github.com/user-attachments/assets/e12871f6-6150-4623-b3ff-77caeb90a806)

# TB Architecture:
![Screenshot 2024-08-23 154447](https://github.com/user-attachments/assets/23af9c76-2e0f-43fd-978e-74193c7a8def)
