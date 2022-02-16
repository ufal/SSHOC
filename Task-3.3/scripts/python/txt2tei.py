#!/usr/bin/env python3
import argparse


INDENTATION_CHAR = "  "


def print_indented(text, level=0):
    print("{}{}".format("".join([INDENTATION_CHAR] * level), text))


def print_header(data):
    print(
        '<?xml version="1.0" encoding="UTF-8"?>\n'
        '<?xml-model http://www.tei-c.org/release/xml/tei/custom/schema/relaxng/tei_all.rng application/xml http://relaxng.org/ns/structure/1.0\n'
        'http://www.tei-c.org/release/xml/tei/custom/schema/relaxng/tei_all.rng application/xml http://purl.oclc.org/dsdl/schematron?>\n'
        '<TEI xmlns="http://www.tei-c.org/ns/1.0">\n'
    )
    print_indented('<teiHeader>', 1)

    print_header_description(data, level=2)
    print_header_cast(data, level=2)
    print_indented('</teiHeader>', 1)


def print_header_description(data, level):
    print_indented('<fileDesc>', level)  # fileDesc BEGIN

    # TITLE
    # TODO: title-type?
    # TODO: author-key?
    print_indented('<titleStmt>', level + 1)
    print_indented('<title>{}</title>'.format(data["title"]), level + 2)  # Drama title
    print_indented('<author>{}</author>'.format(data["author"]), level + 2)  # Drama author
    print_indented('</titleStmt>', level + 1)

    # EDITION
    # TODO: keep empty?
    print_indented('<editionStmt>', level + 1)
    print_indented('<edition n=""></edition>', level +2)
    print_indented('</editionStmt>', level + 1)

    # PUBLICATION
    # TODO: AUTHORITY metadata?
    # TODO: PUBLISHER metadata?
    # TODO: DATE, TIME metadata?
    # TODO: LICENCE metadata?
    print_indented('<publicationStmt>', level + 1)
    print_indented('<p>Information about the publication.</p>', level + 2)
    print_indented('</publicationStmt>', level + 1)

    # DESCRIPTION
    # TODO BIBL metadata?
    # TODO: URL metadata?
    print_indented('<sourceDesc>', level + 1)
    print_indented('<p>{}</p>'.format(data["description"]), level + 2)  # Drama description
    print_indented('</sourceDesc>', level + 1)

    print_indented('</fileDesc>', level)  # fileDesc END

    # ENCODING
    # TODO: keep empty?
    print_indented('<encodingDesc>', level)
    print_indented('<p/>', level + 1)
    print_indented('</encodingDesc>', level)


def print_header_cast(data, level):
    print_indented('<profileDesc>', level)  # profileDesc BEGIN

    print_indented('<particDesc>', level + 1)  # particDesc BEGIN
    print_indented('<listPerson>', level + 2)

    for character in data["cast"]:
        print_header_cast_single(character["xml_id"], character["name"], character["role"], level=(level + 3))

    print_indented('</listPerson>', level + 2)
    print_indented('</particDesc>', level + 1)  # particDesc END

    # TODO: print genre Title here?
    # <textClass>
    #   <keywords>
    #       <term type="genreTitle">???</term>
    #   </keywords>
    # </textClass>

    print_indented('</profileDesc>', level)  # profileDesc END


def print_header_cast_single(xml_id, name, note=None, level=0):
    print_indented('<person xml:id="{}">'.format(xml_id), level)
    print_indented('<persName>{}</persName>'.format(name), level + 1)
    if note is not None:
        print_indented('<note>{}</note>'.format(note), level + 1)
    print_indented('</person>'.format(xml_id), level)


def print_text(data):
    print_indented('<text>', 1)  # text BEGIN

    print_indented('<front>', 2)  # front BEGIN
    
    # TODO: print docAuthor?
    # <docAuthor>???</docAuthor>

    # TODO: print docTitle?
    # <docTitle>
    #   <titlePart type="main">???</titlePart>
    # </docTitle>

    print_text_cast(data, level=3)

    print_indented('</front>', 2)  # front END

    # text end printed elsewhere


def print_text_cast(data, level):
    print_indented('<castList xml:id="{}">'.format(data["castList_id"]), level)  # castList BEGIN

    # TODO: different structure of cast groups?
    print_indented('<castGroup>', level + 1)
    for character in data["cast"]:
        print_text_cast_single(character["name"], character["role"], character["cast_group"], level + 2)
    print_indented('</castGroup>', level + 1)

    print_indented('</castList>', level)  # castList END


def print_text_cast_single(name, role=None, group=None, level=0):
    if group is not None and group:
        print_indented('<castItem n="{}"'.format(group), level)
    else:
        print_indented('<castItem>', level)
        
    print_indented('<role>', level + 1)
    print_indented('<name>{}</name>'.format(name), level + 2)
    print_indented('</role>', level + 1)
    if role is not None and role:
        print_indented('<roleDesc>{}</roleDesc>'.format(role), level + 1)
    print_indented('</castItem>', level)


def print_body_begin():
    print_indented('<body>', 2)


def print_act(i, name):
    if i > 1:
        print_indented('</div>', 4)
        print_indented('</div>', 3)
      
    #print_indented('<div type="act" n="{}" name="{}">'.format(i, name), 3)
    print_indented('<div type="act" n="{}">'.format(i), 3)
    print_indented('<head>{}</head>'.format(name), 4)
    print_indented('<div type="scene">', 4)


def print_body_end():
    print_indented('</div>', 4)
    print_indented('</div>', 3)
    print_indented('</body>', 2)
    print_indented('</text>', 1)
    print('</TEI>')


def print_utterance(utt, level=5):
    if utt is None or not utt:
        return
    if not utt["content"]:
        utt = None
        return

    # TODO: insert proper values into the ``who'' attribute
    print_indented('<sp who="{}">'.format(utt["name"].lower()), level)  # sp BEGIN
    print_indented('<speaker>{}</speaker>'.format(utt["name"]), level + 1)
    for line in utt["content"]:
        if line:  # skip empty lines
            print_indented('<l>{}</l>'.format(line), level + 1)
    print_indented('</sp>', level)  # sp END
    utt = None


def main(args):
    data = {"cast" : [], "castList_id" : args.input_file.split("/")[-1].split("-")[0].lower() }  # Dictionary containing the ``contents'' of the XML template
    cast_hash = {}  # Hash for checking whether a keyword is a character in the play
    utterance = None  # Used to ``buffer'' character utterances from the text
    n_act = 1

    header_printed = False  # We only want to print the header once
    with open(args.input_file, 'r') as in_f:
        line_num = 1
        for line in in_f:
            line = line.strip()
            # Skip empty lines
            if not line:
                continue

            if line[0] == '^' or line[0] == '#':
                # Print header and the beginning of the body
                if not header_printed:
                    print_header(data)
                    print_text(data)
                    print_body_begin()
                    header_printed = True

            if line_num == 1:
                data["title"] = line
            elif line_num == 2:
                data["author"] = line
            elif line_num == 3:
                data["description"] = line
            elif line[0] == '*':
                line = line[2:].split(",")
                if len(line) != 3:
                    raise ValueError(
                        "Line ``* {}'' does not contain three entries "
                        "separated by comma.".format(",".join(line)))
                character = {
                    "name": line[0],
                    "xml_id": "_".join(line[0].split(" ")).lower(),
                    "role": line[1].strip(),
                    "cast_group": line[2].strip(),
                }
                cast_hash[line[0]] = 1
                data["cast"].append(character)
            elif line[0] == '^':  # Act indicator
                print_utterance(utterance)
                print_act(n_act, line[2:])
                n_act += 1
            elif line[0] == '!':  # Act end indicator == do nothing?
                print_utterance(utterance)
            elif line[0] == "#":  # Stage indicator
                if utterance is not None:
                    name = utterance["name"]
                    print_utterance(utterance)
                    utterance = {"name": name, "content": []}
                print_indented('<stage>{}</stage>'.format(line[2:]), 5)
            elif ":" in line:
                print_utterance(utterance)
                name = line.split(":")[0]
                text = line.split(":")[1].strip()
                utterance = {"name": name, "content": [text]}
            elif utterance is not None:
                utterance["content"].append(line.strip())

            line_num += 1
        print_body_end()
        


def parse_args():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--input-file", type=str, required=True,
        help="Location of the input TEI XML file.")
    # TODO: add argument for user-specified meta-data
    return parser.parse_args()


if __name__ == '__main__':
    main(parse_args())
