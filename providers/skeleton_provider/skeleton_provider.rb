#!/usr/bin/env ruby

class MyProvider < Provider

  def create(inputmap)
    flavor = inputmap['flavor']
    image = inputmap['image']
    hostname = inputmap['hostname']
    #
    # implement requesting a machine from provider
    #
    @result['status'] = 0
    @result['result']['foo'] = "bar"
  end

  def confirm(inputmap)
    providerid = inputmap['providerid']
    #
    # implement confirmation/validation of this machine from provider
    #
    @result['status'] = 0
  end

  def delete(inputmap)
    providerid = inputmap['providerid']
    #
    # implement deletion of machine from provider
    #
    @result['status'] = 0
  end

end
