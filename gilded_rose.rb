class ItemWrapper
  attr_accessor :item
  def initialize(item)
    @item = item
  end

  def sell_in
    item.sell_in
  end

  def sell_in=(n)
    item.sell_in = n
  end

  def quality=(n)
    original_quality = item.quality
    item.quality = n
    item.quality = 0 if item.quality < 0
    if item.quality > 50
      item.quality = [original_quality, 50].max
    end
  end

  def quality
    item.quality
  end
end

class Sulfuras < ItemWrapper
  def update_quality
    self.quality += 1
  end
end

class Normal < ItemWrapper
  def update_quality
    self.quality -= 1
    self.sell_in -= 1
    if sell_in < 0
      self.quality -= 1
    end
  end
end

class AgedBrie < ItemWrapper
  def update_quality
    self.sell_in -= 1
    if sell_in < 0
      self.quality += 2
    else
      self.quality += 1
    end
  end
end

class BackstagePass < ItemWrapper
  def update_quality
    self.quality += 1
    self.quality += 1 if sell_in < 11
    self.quality += 1 if sell_in < 6
    self.sell_in -= 1
    self.quality = 0 if sell_in < 0
  end
end

ITEM_CLASSES = {
  'Backstage passes to a TAFKAL80ETC concert' => BackstagePass,
  'Aged Brie' => AgedBrie,
  'Sulfuras, Hand of Ragnaros' => Sulfuras
}.freeze

def update_quality(items)
  items.each do |item|
    item = ITEM_CLASSES.fetch(item.name, Normal).new(item)
    item.update_quality
  end
end

# DO NOT CHANGE THINGS BELOW -----------------------------------------

Item = Struct.new(:name, :sell_in, :quality)

# We use the setup in the spec rather than the following for testing.
#
# Items = [
#   Item.new("+5 Dexterity Vest", 10, 20),
#   Item.new("Aged Brie", 2, 0),
#   Item.new("Elixir of the Mongoose", 5, 7),
#   Item.new("Sulfuras, Hand of Ragnaros", 0, 80),
#   Item.new("Backstage passes to a TAFKAL80ETC concert", 15, 20),
#   Item.new("Conjured Mana Cake", 3, 6),
# ]

