# frozen_string_literal: true

RSpec.describe "CLI appraisal (with no arguments)" do
  it "runs install command" do
    build_appraisal_file <<-APPRAISAL.strip_heredoc.rstrip
      appraise '1.0.0' do
        gem 'dummy', '1.0.0'
      end
    APPRAISAL

    run "appraisal"

    expect(file("gemfiles/1.0.0.gemfile")).to be_exists
    expect(file("gemfiles/1.0.0.gemfile.lock")).to be_exists
  end
end
