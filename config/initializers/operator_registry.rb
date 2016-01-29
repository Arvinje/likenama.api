class OperatorRegistry
  @@operators = {}
  @@details = {}

  def self.load!
    Dir[Rails.application.root.to_s + "/app/operators/*.rb"].each { |file| require_dependency file }

    Module.constants
      .map(&:to_s)
      .select { |name| name.end_with? "Operator" }
      .each do |name|
        type = name.chomp("Operator").downcase.to_sym
        operator = Object.const_get name
        detail = Object.const_get "#{name.chomp('Operator')}Detail"

        register(type, operator, detail)
      end
  end

  def self.register(type, operator, detail)
    @@operators[type] = operator
    @@details[type] = detail
  end

  def self.operator_for(type)
    @@operators.fetch(type.to_sym) { InstagramOperator }
  end

  def self.detail_for(type)
    @@details.fetch(type.to_sym) { InstagramDetail }
  end

  def self.available_types
     @@operators.keys.map(&:to_s)
  end

end

OperatorRegistry.load!
