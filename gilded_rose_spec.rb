require 'rspec'

require File.join(File.dirname(__FILE__), 'gilded_rose')

describe GildedRose do
  it "does not change the name" do
    items = [Item.new("foo", 0, 0)]
    expect { GildedRose.new(items).update_quality }.not_to change { items.first.name }
  end

  it "degrades both sell_in and quality" do
    items = [Item.new("foo", 3, 5)]
    expect { GildedRose.new(items).update_quality }
    .to change { items.first.quality }.by(-1)
    .and change {items.first.sell_in}.by(-1)
  end

  it "degrades quality twice faster after expiration" do
    items = [Item.new("foo", 0, 5)]
    expect { GildedRose.new(items).update_quality }
    .to change { items.first.quality }.by(-2)
    .and change {items.first.sell_in}.by(-1)
  end

  context "Zero quality" do
    it "does not negate the quality" do
      items = [Item.new("foo", 5, 0)]
      expect { GildedRose.new(items).update_quality }.not_to change { items.first.quality }
    end

    it "does not negate the quality after expiration" do
      items = [Item.new("foo", 0, 1)]
      expect { GildedRose.new(items).update_quality }.to change { items.first.quality }.to(0)
    end
  end

  it "Brie: increases quality and degrades sell_in" do
    items = [Item.new("Aged Brie", 10, 10)]
    expect { GildedRose.new(items).update_quality }
    .to change { items.first.quality }.by(1)
    .and change {items.first.sell_in}.by(-1)
  end

  it "does not set quality more than 50" do
    items = [Item.new("Aged Brie", 10, 50)]
    expect { GildedRose.new(items).update_quality }.not_to change { items.first.quality }
  end

  it "does not change the Sulfuras" do
    items = [Item.new("Sulfuras, Hand of Ragnaros", 10, 10)]
    expect { GildedRose.new(items).update_quality }.not_to change { items.first }
  end

  context "Backstage passes" do
    it "increases quality by 1 for sell_in>10" do
      items = [Item.new("Backstage passes to a TAFKAL80ETC concert", 13, 3)]
      expect { GildedRose.new(items).update_quality }
        .to change { items.first.quality }.by(1)
        .and change { items.first.sell_in }.by(-1)
    end

    (6..10).each do |sell_in_value|
      it "increases quality by 2 for sell_in=#{sell_in_value}" do
        items = [Item.new("Backstage passes to a TAFKAL80ETC concert", sell_in_value, 3)]
        expect { GildedRose.new(items).update_quality }
          .to change { items.first.quality }.by(2)
          .and change { items.first.sell_in }.by(-1)
      end
    end

    (1..5).each do |sell_in_value|
      it "increases quality by 3 for sell_in=#{sell_in_value}" do
        items = [Item.new("Backstage passes to a TAFKAL80ETC concert", sell_in_value, 3)]
        expect { GildedRose.new(items).update_quality }
          .to change { items.first.quality }.by(3)
          .and change { items.first.sell_in }.by(-1)
      end
    end

    it "drops quality after the concert" do
      items = [Item.new("Backstage passes to a TAFKAL80ETC concert", 0, 15)]
      expect { GildedRose.new(items).update_quality }
      .to change { items.first.quality }.to(0)
      .and change { items.first.sell_in }.by(-1)
    end

    (5..6).each do |sell_in_value|
      (48..50).each do |quality_value|
        it "does not set quality more than 50 for [#{sell_in_value},#{quality_value}]" do
          items = [Item.new("Backstage passes to a TAFKAL80ETC concert", sell_in_value, quality_value)]
          gilded_rose = GildedRose.new(items)
          gilded_rose.update_quality
          expect(items.first.quality).not_to be > 50
        end
      end
    end
  end

  context "Conjured" do
    it "degrades quality twice as fast as normal items" do
      items = [Item.new("Conjured Mana Cake", 3, 8)]
      expect { GildedRose.new(items).update_quality }
      .to change { items.first.quality }.by(-2)
      .and change {items.first.sell_in}.by(-1)
    end

    it "degrades quality twice faster after expiration" do
      items = [Item.new("Conjured Mana Cake", 0, 8)]
      expect { GildedRose.new(items).update_quality }
      .to change { items.first.quality }.by(-4)
      .and change {items.first.sell_in}.by(-1)
    end

    3.downto(1) do |quality_value|
      it "does not make negative quality after expiration for quality=#{quality_value}" do
        items = [Item.new("Conjured Mana Cake", 0, quality_value)]
        expect { GildedRose.new(items).update_quality }
          .to change { items.first.quality }.to(0)
          .and change { items.first.sell_in }.by(-1)
      end
    end
  end
end
