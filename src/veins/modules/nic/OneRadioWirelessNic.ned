//
// Copyright (C) 2011 David Eckhoff <eckhoff@cs.fau.de>
//
// Documentation for these modules is at http://veins.car2x.org/
//
// This program is free software; you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation; either version 2 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program; if not, write to the Free Software
// Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
//

package org.car2x.veins.modules.nic;

//
// This NIC implements a wireless network interface controller.
//
// @author Julian Heinovski
//
// @see IWirelessMac
// @see IWirelessPhy
//
module OneRadioWirelessNic like IWirelessNic
{
    parameters:
        string phyType = default("PhyLayer80211p"); // type of physical layer
        string macType = default("Mac1609_4"); // type of mac layer

    gates:
        input upperLayerIn; // to upper layers
        output upperLayerOut; // from upper layers
        output upperControlOut; // control information
        input upperControlIn; // control information
        input radioIn; // radioIn gate for sendDirect

    submodules:
        phy: <phyType> like org.car2x.veins.base.phyLayer.IWirelessPhy {
            @display("p=69,218;i=block/process_s");
        }

        mac: <macType> like org.car2x.veins.base.modules.IWirelessMac {
            @display("p=69,82");
        }

    connections:
        radioIn --> phy.radioIn;

        mac.lowerControlOut --> phy.upperControlIn;
        mac.lowerLayerOut --> phy.upperLayerIn;
        phy.upperLayerOut --> mac.lowerLayerIn;
        phy.upperControlOut --> mac.lowerControlIn;

        mac.upperControlIn <-- upperControlIn;
        mac.upperLayerIn <-- upperLayerIn;

        mac.upperLayerOut --> upperLayerOut;
        mac.upperControlOut --> upperControlOut;
}
