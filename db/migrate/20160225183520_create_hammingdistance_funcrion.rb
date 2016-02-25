class CreateHammingdistanceFuncrion < ActiveRecord::Migration
  def change


      stmt = "CREATE FUNCTION HAMMINGDISTANCE(A BINARY(32), B BINARY(32)) " \
      "RETURNS INT DETERMINISTIC " \
      "RETURN " \
      "BIT_COUNT(" \
      "CONV(HEX(SUBSTRING(A, 1,  8)), 16, 10) ^" \
      "CONV(HEX(SUBSTRING(B, 1,  8)), 16, 10)" \
      ") +" \
      "BIT_COUNT(" \
      "  CONV(HEX(SUBSTRING(A, 9,  8)), 16, 10) ^" \
      "  CONV(HEX(SUBSTRING(B, 9,  8)), 16, 10)" \
      ") +" \
      "BIT_COUNT(" \
      "  CONV(HEX(SUBSTRING(A, 17, 8)), 16, 10) ^" \
      "  CONV(HEX(SUBSTRING(B, 17, 8)), 16, 10)" \
      ") +" \
      "BIT_COUNT(" \
      "  CONV(HEX(SUBSTRING(A, 25, 8)), 16, 10) ^" \
      "  CONV(HEX(SUBSTRING(B, 25, 8)), 16, 10)" \
      ");"

      ActiveRecord::Base.connection.execute stmt


  end
end
