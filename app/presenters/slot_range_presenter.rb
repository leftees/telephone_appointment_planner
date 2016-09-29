class SlotRangePresenter < SimpleDelegator
  def title
    "#{from.strftime('%d %B %Y')} ➡ onwards"
  end

  def self.wrap(objects)
    objects.map { |o| new(o) }
  end
end
