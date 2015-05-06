module Qt
  module SpecHelpers
    def find(widget, object_name)
      return widget if widget.object_name == object_name
      widget.children.each do |child|
        result = find(child, object_name)
        return result if result != nil
      end
      nil
    end
  end
end
