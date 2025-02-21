# frozen_string_literal: true

RSpec.describe "Appraisals file Bundler DSL compatibility" do
  it "supports all Bundler DSL in Appraisals file", :git_local do
    build_gems %w[
      bagel
      orange_juice
      milk
      waffle
      coffee
      ham
      sausage
      pancake
      rotten_egg
      mayonnaise
    ]
    build_git_gems %w[egg croissant pain_au_chocolat omelette]

    build_gemfile <<-GEMFILE.strip_heredoc.rstrip
      source 'https://rubygems.org'
      git_source(:custom_git_source) { |repo| "../build/\#{repo}" }
      ruby "#{RUBY_VERSION}#{ruby_dev_append}"

      gem 'bagel'
      gem "croissant", :custom_git_source => "croissant"

      git '../build/egg' do
        gem 'egg'
      end

      path '../build/waffle' do
        gem 'waffle'
      end

      group :breakfast do
        gem 'orange_juice'
        gem "omelette", :custom_git_source => "omelette"
        gem 'rotten_egg'
      end

      platforms :ruby, :jruby do
        gem 'milk'

        group :lunch do
          gem "coffee"
        end
      end

      source "https://other-rubygems.org" do
        gem "sausage"
      end

      install_if '"-> { true }"' do
        gem 'mayonnaise'
      end

      gem 'appraisal', :path => #{PROJECT_ROOT.inspect}
    GEMFILE

    build_appraisal_file <<-APPRAISALS.strip_heredoc.rstrip
      appraise 'breakfast' do
        source 'http://some-other-source.com'
        ruby "1.8.7"

        gem 'bread'
        gem "pain_au_chocolat", :custom_git_source => "pain_au_chocolat"

        git '../build/egg' do
          gem 'porched_egg'
        end

        path '../build/waffle' do
          gem 'chocolate_waffle'
        end

        group :breakfast do
          remove_gem 'rotten_egg'
          gem 'bacon'

          platforms :rbx do
            gem "ham"
          end
        end

        platforms :ruby, :jruby do
          gem 'yoghurt'
        end

        source "https://other-rubygems.org" do
          gem "pancake"
        end

        install_if "-> { true }" do
          gem 'ketchup'
        end

        gemspec
        gemspec :path => "sitepress"
      end
    APPRAISALS

    run "bundle install --local"
    run "appraisal generate"

    expect(content_of("gemfiles/breakfast.gemfile")).to eq <<-GEMFILE.strip_heredoc.rstrip
      # This file was generated by Appraisal

      source "https://rubygems.org"
      source "http://some-other-source.com"

      ruby "1.8.7"

      git "../../build/egg" do
        gem "egg"
        gem "porched_egg"
      end

      path "../../build/waffle" do
        gem "waffle"
        gem "chocolate_waffle"
      end

      gem "bagel"
      gem "croissant", :git => "../../build/croissant"
      gem "appraisal", :path => #{PROJECT_ROOT.inspect}
      gem "bread"
      gem "pain_au_chocolat", :git => "../../build/pain_au_chocolat"

      group :breakfast do
        gem "orange_juice"
        gem "omelette", :git => "../../build/omelette"
        gem "bacon"
        
        platforms :rbx do
          gem "ham"
        end
      end

      platforms :ruby, :jruby do
        gem "milk"
        gem "yoghurt"
        
        group :lunch do
          gem "coffee"
        end
      end

      source "https://other-rubygems.org" do
        gem "sausage"
        gem "pancake"
      end

      install_if -> { true } do
        gem "mayonnaise"
        gem "ketchup"
      end

      gemspec :path => "../"
      gemspec :path => "../sitepress"
    GEMFILE
  end

  it 'supports ruby file: ".ruby-version" DSL' do
    build_gemfile <<-GEMFILE.strip_heredoc.rstrip
      source 'https://rubygems.org'

      ruby "#{RUBY_VERSION}#{ruby_dev_append}"

      gem 'appraisal', :path => #{PROJECT_ROOT.inspect}
    GEMFILE

    build_appraisal_file <<-APPRAISALS.strip_heredoc.rstrip
      appraise 'ruby-version' do
        ruby({:file => ".ruby-version"})
      end
    APPRAISALS

    run "bundle install --local"
    run "appraisal generate"

    expect(content_of("gemfiles/ruby_version.gemfile")).to eq <<-GEMFILE.strip_heredoc.rstrip
      # This file was generated by Appraisal

      source "https://rubygems.org"

      ruby(:file => ".ruby-version")

      gem "appraisal", :path => #{PROJECT_ROOT.inspect}
    GEMFILE
  end
end
