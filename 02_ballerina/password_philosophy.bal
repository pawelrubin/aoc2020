import ballerina/io;
import ballerina/regex;

type Template record {
    int min;
    int max;
    string char;
    string password;
};

function get_template(string str) returns Template {

    string[] splitted = regex:split(str, ":");
    string policy = splitted[0];
    string password = splitted[1].trim();

    string[] policy_splitted = regex:split(policy, " ");
    string min_max = policy_splitted[0];
    string char = policy_splitted[1];
    string[] min_max_splitted = regex:split(min_max, "-");
    int min = checkpanic int:fromString(min_max_splitted[0]);
    int max = checkpanic int:fromString(min_max_splitted[1]);
    Template t = {
        min: min,
        max: max,
        char: char,
        password: password
    };

    return t;
}

function count_valid_passwords(string[] passwords) returns int[] {
    return passwords.reduce(
        function(int[] acc, string p) returns int[] {
        Template template = get_template(p);

        int count = template.password.toCodePointInts()
            .filter(ch => checkpanic string:fromCodePointInt(ch) == template.char)
            .length();

        if count <= template.max && count >= template.min {
            acc[0] += 1;
        }

        count = 0;
        if checkpanic string:fromCodePointInt(template.password.getCodePoint(template.min - 1)) == template.char {
            count += 1;
        }
        if checkpanic string:fromCodePointInt(template.password.getCodePoint(template.max - 1)) == template.char {
            count += 1;
        }

        if count == 1 {
            acc[1] += 1;
        }

        return acc;
    }
    , [0, 0]);
}

public function main() {
    io:ReadableByteChannel readableFieldResult = checkpanic io:openReadableFile("input.txt");
    io:ReadableCharacterChannel sourceChannel = new (readableFieldResult, "UTF-8");
    io:println(count_valid_passwords(checkpanic sourceChannel.readAllLines()));
}

