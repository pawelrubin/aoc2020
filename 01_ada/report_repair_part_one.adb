with Ada.Text_IO;    use Ada.Text_IO;
with Ada.Containers; use Ada.Containers;
with Ada.Containers.Ordered_Sets;

procedure Report_Repair_Part_One is
   package Positive_Sets is new Ada.Containers.Ordered_Sets
     (Element_Type => Positive);

   use Positive_Sets;
   year       : constant Integer := 2_020;
   F          : File_Type;
   File_Name  : constant String  := "input.txt";
   seen       : Set;
   num        : Positive;
   complement : Positive;
   product    : Positive;
begin
   Open (F, In_File, File_Name);
   while not End_Of_File (F) loop
      num        := Integer'Value (Get_Line (F));
      complement := year - num;
      if seen.Contains (complement) then
         product := (num * complement);
         Put_Line (product'Img);
         exit;
      end if;
      seen.Insert (num);
   end loop;
   Close (F);
end Report_Repair_Part_One;
