with Ada.Text_IO;    use Ada.Text_IO;
with Ada.Containers; use Ada.Containers;
with Ada.Containers.Ordered_Sets;

procedure Report_Repair_Part_Two is

   package Positive_Sets is new Ada.Containers.Ordered_Sets
     (Element_Type => Positive);

   use Positive_Sets;
   year       : constant Positive := 2_020;
   F          : File_Type;
   File_Name  : constant String   := "input.txt";
   sum        : Positive;
   complement : Positive;
   product    : Positive;
   numbers    : Set;
begin
   Open (F, In_File, File_Name);
   while not End_Of_File (F) loop
      numbers.Insert (Integer'Value (Get_Line (F)));
   end loop;
   Close (F);

   outer :
   for x of numbers loop
      for y of numbers loop
         sum := x + y;
         if sum < year then
            complement := year - sum;
            if numbers.Contains (complement) then
               product := (x * y * complement);
               Put_Line (product'Img);
               exit outer;
            end if;
         end if;
      end loop;
   end loop outer;

end Report_Repair_Part_Two;
