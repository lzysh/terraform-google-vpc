project_id = input('project_id')
network_name = input('network_name')

control 'google-compute-network' do
  title 'Google Compute Network'

  describe google_compute_network(project: project_id, name: network_name) do
    it { should exist }
  end
end
