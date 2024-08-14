# Title: Simple TCL script to create wireless Scenario.
# Date: 7 August, 2024.
# Author: Rachit Patekar.

# Initialize variables
set val(chan)           Channel/WirelessChannel    ;# Channel Type
set val(prop)           Propagation/TwoRayGround   ;# Radio-propagation model
set val(netif)          Phy/WirelessPhy            ;# Network interface type WAVELAN DSSS 2.4GHz
set val(mac)            Mac/802_11                 ;# MAC type
set val(ifq)            Queue/DropTail/PriQueue    ;# Interface queue type
set val(ll)             LL                         ;# Link layer type
set val(ant)            Antenna/OmniAntenna        ;# Antenna model
set val(ifqlen)         50                         ;# Max packet in ifq
set val(nn)             2                          ;# Number of mobile nodes
set val(rp)             AODV                       ;# Routing protocol
set val(x)              500                        ;# X dimension in meters
set val(y)              500                        ;# Y dimension in meters

# Creation of Simulator
set ns [new Simulator]

# Creation of Trace and NAM files
set tracefile [open wireless_2.tr w]
$ns trace-all $tracefile
set namfile [open wireless_2.nam w]
$ns namtrace-all-wireless $namfile $val(x) $val(y)

# Create topography
set topo [new Topography]
$topo load_flatgrid $val(x) $val(y)

# Create GOD (General Operations Director)
create-god $val(nn)

# Configure nodes
$ns node-config -adhocRouting $val(rp) \
  -llType $val(ll) \
  -macType $val(mac) \
  -ifqType $val(ifq) \
  -ifqLen $val(ifqlen) \
  -antType $val(ant) \
  -propType $val(prop) \
  -phyType $val(netif) \
  -topoInstance $topo \
  -agentTrace ON \
  -macTrace ON \
  -routerTrace ON \
  -movementTrace ON \
  -channel [new $val(chan)] 

# Node Creation
set n0 [$ns node]
set n1 [$ns node]

# Initial Node Positions
$n0 set X_ 10.0
$n0 set Y_ 20.0
$n0 set Z_ 0.0
$n1 set X_ 430.0
$n1 set Y_ 320.0
$n1 set Z_ 0.0
$n0 color red
$n1 color blue
# Mobility of the nodes
$ns at 1.0 "$n0 setdest 490.0 340.0 25.0"
$ns at 1.0 "$n1 setdest 300.0 130.0 5.0"
$ns at 20.0 "$n1 setdest 100.0 200.0 30.0"

# Create and configure agents
set tcp [new Agent/TCP]
set sink [new Agent/TCPSink]
$ns attach-agent $n0 $tcp
$ns attach-agent $n1 $sink
$ns connect $tcp $sink

# Create and start FTP application
set ftp [new Application/FTP]
$ftp attach-agent $tcp
$ns at 1.0 "$ftp start"

# Finish simulation
$ns at 30.0 "finish"

proc finish {} {
 global ns tracefile namfile
 $ns flush-trace
 close $tracefile
 close $namfile
 exec nam wireless_2.nam &
 exit 0
}

puts "Starting Simulation"
$ns run
