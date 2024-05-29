class GildedRose

  def initialize(items)
    @items = items
  end

  def update_quality()
    @items.each do |item|
      case item.name
      when "Sulfuras, Hand of Ragnaros"
        next
      when "Aged Brie"
        item.quality += 1
      when "Backstage passes to a TAFKAL80ETC concert"
        increment = 3 - item.sell_in.pred.clamp(0,10).div(5)
        item.sell_in <= 0 ? item.quality = 0 : item.quality += increment
      else
        multiplier = item.name.eql?("Conjured Mana Cake") ? 2 : 1
        item.quality -= (item.sell_in > 0 ? 1 : 2) * multiplier
      end

      item.sell_in -= 1
      item.quality = item.quality.clamp(0, 50)
    end
  end
end

class Item
  attr_accessor :name, :sell_in, :quality

  def initialize(name, sell_in, quality)
    @name = name
    @sell_in = sell_in
    @quality = quality
  end

  def to_s()
    "#{@name}, #{@sell_in}, #{@quality}"
  end
end
