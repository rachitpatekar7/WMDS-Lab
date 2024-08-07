# Title: Simple TCL script to create wired Scenario (UDP/CBR).
# Date: 7 July, 2024.
# Author: Rachit Patekar.

set ns [new Simulator]

set namfile [open wired.nam w]
$ns namtrace-all $namfile

set tracefile [open wired.tr w]
$ns trace-all $tracefile

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]

$ns duplex-link $n0 $n1 2Mb 1ms DropTail
$ns duplex-link $n1 $n2 2Mb 1ms DropTail
$ns duplex-link $n2 $n3 2Mb 1ms DropTail
$ns duplex-link $n3 $n0 2Mb 1ms DropTail

$ns at 0.0 "$n0 label sourcenode"
$ns at 0.0 "$n3 label destinationnode"

$n0 color blue
$n3 color red

set udp0 [new Agent/UDP]
#set sink [new Agent/TCPSink]

$ns attach-agent $n0 $udp0
#$ns attach-agent $n3 $sink

set ftp [new Application/Traffic/CBR]
#$ftp attach-agent $tcp

$cbr0 set packetSize_ 500
$cbr0 set interval_ 0.005
$cbr0 attach-agent $udp0

set null0 [new Agent/Null]
$ns attach-agent $n1 $null0

#$ns connect $tcp $sink

$ns at 0.5 "$cbr0 start"
$ns at 4.5 "$cbr0 stop"
$ns at 5.0 "finish"

proc finish {} {
    global ns namfile tracefile
    $ns flush-trace
    close $namfile
    close $tracefile
    exec nam wired.nam &
    exit 0
}

$ns run
