class OperatorRegistry
  @@registry = {}

  def self.load!
    Dir[Rails.application.root.to_s + "/app/operators/*.rb"].each { |file| require_dependency file }

    Module.constants
      .map(&:to_s)
      .select { |name| name.end_with? "Operator" }
      .each do |name|
        method = name.chomp("Operator").downcase.to_sym
        operator = Object.const_get name

        register(method, operator)
      end
  end

  def self.register(method, operator)
    @@registry[method] = operator
  end

  def self.operator_for(method)
    @@registry.fetch(method.to_sym)
  end

end

OperatorRegistry.load!
