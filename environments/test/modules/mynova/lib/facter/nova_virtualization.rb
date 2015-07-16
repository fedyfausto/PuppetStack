    # virtualization.rb

    Facter.add('nova_virtualization') do
      setcode do
        Facter::Core::Execution.exec('egrep -c \'(vmx|svm)\' /proc/cpuinfo')
      end
    end
