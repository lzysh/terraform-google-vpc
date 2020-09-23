project_id = input('project_id')
network_name = input('network_name')

control 'attributes' do
  title 'Terraform Outputs'

  describe input('shared_vpc_self_link') do
    it { should eq "https://www.googleapis.com/compute/v1/projects/#{project_id}/global/networks/#{network_name}" }
  end

  describe input('project_id') do
    it { should eq project_id }
  end

  describe input('network_name') do
    it { should eq network_name }
  end

  describe input('subnet_ips') do
    it { should eq ['172.23.21.0/24'] }
  end
end
