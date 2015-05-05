module Qt
  module SpecHelpers
    def find(widget, object_name)
      widget.children
        .select{|child| child.object_name == object_name}
        .first
    end
  end
end
