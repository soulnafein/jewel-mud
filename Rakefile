require 'rake'
require 'spec/rake/spectask'
require 'metric_fu'

desc "Run all examples"

Spec::Rake::SpecTask.new('spec') do |t|
  t.spec_files = FileList['spec/**/*.rb']
  t.rcov = true
end
