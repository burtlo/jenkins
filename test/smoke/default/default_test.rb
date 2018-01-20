# # encoding: utf-8

# Inspec test for recipe jenkins::default

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

describe command('curl http://localhost:8080') do
  its(:stdout) { should match /Authentication required/ }
end
