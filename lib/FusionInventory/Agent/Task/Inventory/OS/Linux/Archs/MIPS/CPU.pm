package FusionInventory::Agent::Task::Inventory::OS::Linux::Archs::MIPS::CPU;

use strict;
use warnings;

sub isInventoryEnabled { can_read("/proc/cpuinfo") }

sub doInventory {
    my $params = shift;
    my $inventory = $params->{inventory};

    my @cpu;
    my $current;
    if (open my $handle, '<', '</proc/cpuinfo') {
        while(<$handle>) {
            print;
            if (/^system type\s+:\s*:/) {

                if ($current) {
                    $inventory->addCPU($current);
                }

                $current = {
                    ARCH => 'MIPS',
                };

            }

            $current->{TYPE} = $1 if /cpu model\s+:\s+(\S.*)/;

        }
        close $handle;
    } else {
        warn "Can't open $file: $ERRNO";
    }

    # The last one
    $inventory->addCPU($current);
}

1
