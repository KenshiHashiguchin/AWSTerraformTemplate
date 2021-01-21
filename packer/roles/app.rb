# frozen_string_literal: true

COOKBOOKS = %w[
  awslogs
  base
  cloudwatch
  codedeploy
  env-aws-params
  inspector
  nginx
  nodejs
  php
].freeze

COOKBOOKS.each do |cookbook|
  include_recipe "../cookbooks/#{cookbook}/default.rb"
end
