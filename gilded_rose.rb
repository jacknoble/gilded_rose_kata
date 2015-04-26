class ItemWrapper
  MAX_QUALITY = 50
  MINIMUM_QUALITY = 0

  attr_accessor :item

  def initialize(item)
    @item = item
  end

  def sell_in
    item.sell_in
  end

  def sell_in=(days)
    item.sell_in = days
  end

  def quality=(level)
    original_quality = item.quality
    item.quality = level
    item.quality = MINIMUM_QUALITY if item.quality < MINIMUM_QUALITY
    if item.quality > MAX_QUALITY
      item.quality = [original_quality, MAX_QUALITY].max
    end
  end

  def quality
    item.quality
  end

  def expired?
    sell_in < 0
  end

  def age_item
    self.sell_in -= 1
  end
end

class Sulfuras < ItemWrapper
  def update_quality
    self.quality += 1
  end
end

class Normal < ItemWrapper
  EXPIRED_QUALITY_LOSS = 2
  UNEXPIRED_QUALITY_LOSS = 1
  def update_quality
    age_item
    if expired?
      self.quality -= EXPIRED_QUALITY_LOSS
    else
      self.quality -= UNEXPIRED_QUALITY_LOSS
    end
  end
end

class AgedBrie < ItemWrapper
  EXPIRED_QUALITY_GAIN = 2
  UNEXPIRED_QUALITY_GAIN = 1

  def update_quality
    age_item
    if expired?
      self.quality += EXPIRED_QUALITY_GAIN
    else
      self.quality += UNEXPIRED_QUALITY_GAIN
    end
  end
end

class BackstagePass < ItemWrapper
  def update_quality
    age_item
    if expired?
      self.quality = 0 and return
    end
    self.quality +=
      case sell_in
      when 10..Float::INFINITY then 1
      when 5..10 then 2
      when 0..5 then 3
      end
  end
end

class Conjured < ItemWrapper
  EXPIRED_QUALITY_LOSS = 4
  UNEXPIRED_QUALITY_LOSS = 2
  def update_quality
    age_item
    if expired?
      self.quality -= EXPIRED_QUALITY_LOSS
    else
      self.quality -= UNEXPIRED_QUALITY_LOSS
    end
  end
end

ITEM_CLASSES = {
  'Backstage passes to a TAFKAL80ETC concert' => BackstagePass,
  'Aged Brie' => AgedBrie,
  'Sulfuras, Hand of Ragnaros' => Sulfuras,
  "Conjured Mana Cake" => Conjured
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

