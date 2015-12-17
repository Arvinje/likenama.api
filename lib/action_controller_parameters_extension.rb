module ActionControllerParametersExtension
  extend ActiveSupport::Concern

  # Runs the traverser on a copy of Parameters' instance so
  # the output would also be an instance of Parameters.
  def fix_numerals
    hash = self.clone
    traverse hash
    hash
  end

  # A recursive method to traverse the params hash. It replaces
  # persian numerals with their equivalent english numerals.
  # It's not the best way to do it, but it works for now.
  def traverse(element)
    case element
    when Hash
      element.each{ |k,v| element[k] = traverse(v) }
    when Array
      element.map{ |v| traverse(v) }
    else
      element.tr("۱۲۳۴۵۶۷۸۹۰", "1234567890")
    end
  end

end

# Includes the extension
ActionController::Parameters.send(:include, ActionControllerParametersExtension)
