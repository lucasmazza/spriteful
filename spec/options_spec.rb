require "spec_helper"

describe Spriteful do

  describe ".optimize_svg?" do
    it "returns true by default" do
      expect(described_class.optimize_svg?).to be true
    end

    context "when the --no-optimize-svg option is set" do
      before do
        described_class.options = ["--no-optimize-svg"]
      end

      it "returns false by default" do
        expect(described_class.optimize_svg?).to be false
      end
    end
  end
end
