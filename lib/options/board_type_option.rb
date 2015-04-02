class BoardTypeOption
  def initialize(selection, factory)
    @selection = selection
    @factory = factory
  end

  def get
    factory.create(selection.read)
  end

  private
  attr_accessor :selection, :factory
end
