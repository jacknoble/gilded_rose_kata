class ItemWrapper
  attr_accessor :item
  def initialize(item)
    @item = item
  end

  def name
    item.name
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

  def backstage_update
    if sell_in < 6
      self.quality += 3
    elsif sell_in < 11
      self.quality += 2
    else
      self.quality += 1
    end
    self.sell_in -= 1
    self.quality = 0 if sell_in < 0
  end

  def brie_update
    self.sell_in -= 1
    if sell_in < 0
      self.quality += 2
    else
      self.quality += 1
    end
  end

  def sulfuras_update
    self.quality += 1
  end

  def normal_update
    self.quality -= 1
    self.sell_in -= 1
    if sell_in < 0
      self.quality -= 1
    end
  end

  def quality
    item.quality
  end
end

def update_quality(items)
  items.each do |item|
    item = ItemWrapper.new(item)
    if item.name == 'Backstage passes to a TAFKAL80ETC concert'
      item.backstage_update
      return
    end

    if item.name == 'Aged Brie'
      item.brie_update
      return
    end

    if item.name == 'Sulfuras, Hand of Ragnaros'
      item.sulfuras_update
      return
    end

    item.normal_update
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

