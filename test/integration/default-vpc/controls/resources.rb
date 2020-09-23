project_id = input('project_id')
network_name = input('network_name')

control "gcp-resources" do
    title "Google Cloud Resoruces"
  
    describe google_compute_firewalls(project: project_id) do
      its('firewall_names') { should include "#{network_name}-allow-rfc1918-icmp" }
      its('firewall_names') { should include "#{network_name}-allow-health-check" }
    end
  end