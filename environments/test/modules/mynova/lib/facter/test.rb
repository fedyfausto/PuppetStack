    # hardware_test.rb

    Facter.add('test') do
      setcode do
        Facter::Core::Execution.exec('/bin/uname --hardware-platform')
      end
    end
