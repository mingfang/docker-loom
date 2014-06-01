class SshProvider < Provider
  def create(inputmap)
    hostname = inputmap['hostname']
    fields = inputmap['fields']

    begin
      @result['status'] = 0
    end
  end

  def confirm(inputmap)
    @result['status'] = 0
  end

  def delete(inputmap)
    @result['status'] = 0
  end
end