import glob
import os

from typesense.api_call import ObjectNotFound
from acdh_cfts_pyutils import TYPESENSE_CLIENT as client
from acdh_tei_pyutils.tei import TeiReader
from acdh_tei_pyutils.utils import (
    extract_fulltext,
    make_entity_label,
)
from tqdm import tqdm


class Person:
    def __init__(self, id):
        self.id = id
        self.reg = ""
        self.found = False
        self.forename = ""
        self.surname = ""
        self.letter = ""
        self.gnd = ""
        self.birth = ""
        self.death = ""
        self.isMDB = False


def CreatePersonIndex(personregister, person_found):
    COLLECTION_NAME = "kgparl_persons"

    try:
        client.collections[COLLECTION_NAME].delete()
    except ObjectNotFound:
        pass

    current_schema = {
        "name": COLLECTION_NAME,
        "enable_nested_fields": False,
        "fields": [
            {"name": "id", "type": "string"},
            {"name": "rec_id", "type": "string", "facet": True,
                "optional": False, "sort": True},
            {"name": "birth", "type": "string", "optional": True},
            {"name": "death", "type": "string", "optional": True},
            {"name": "birth_place", "type": "string", "optional": True},
            {"name": "death_place", "type": "string", "optional": True},
            {"name": "birth_country", "type": "string", "optional": True},
            {"name": "death_country", "type": "string", "optional": True},
            {"name": "forename", "type": "string"},
            {"name": "surname", "type": "string", "sort": True},
            {"name": "letter", "type": "string", "facet": True,
                "optional": False, "sort": True, "index": True},
            {"name": "reg", "type": "string", "sort": True, "index": True},
            {"name": "found", "type": "bool", "facet": True,
                "optional": False, "sort": True, "index": True},
            {"name": "gnd", "type": "string", "sort": True,
                "index": True, "optional": True},
            {"name": "isMDB", "type": "bool",
                "optional": True, "sort": True, "index": True},
        ],
        "default_sorting_field": "rec_id",
    }

    client.collections.create(current_schema)

    records = []
    for person in person_found:
        print(person)
        try:

            personid = personregister[person]["id"]
        except KeyError:
            print(f"person not found in personregister: {person}")
            continue
        record = {}
        record["id"] = personid
        record["rec_id"] = personid
        try:
            record["surname"] = personregister[personid]["surname"]
        except IndexError:
            record["surname"] = ""

        try:
            record["forename"] = personregister[personid]["forename"]
        except IndexError:
            record["forename"] = ""

        try:
            record["reg"] = personregister[personid]["reg"]
        except IndexError as e:
            print(f"reg issues in {personid}, due to: {e}")

        try:
            record["letter"] = personregister[personid]["letter"]
        except IndexError:
            record["letter"] = "?"

        try:
            record["gnd"] = personregister[personid]["gnd"]
        except IndexError:
            record["gnd"] = ""

        if personregister[personid]["found"] == "1":
            record["found"] = True
        else:
            record["found"] = False

        record["birth"] = personregister[personid]["birth"]
        if record["birth"] == "":
            record["birth"] = None

        record["death"] = personregister[personid]["death"]
        if record["death"] == "":
            record["death"] = None

        record["birth_place"] = personregister[personid]["birth_place"]
        if record["birth_place"] == "":
            record["birth_place"] = None

        record["death_place"] = personregister[personid]["death_place"]
        if record["death_place"] == "":
            record["death_place"] = None

        record["birth_country"] = personregister[personid]["birth_country"]
        if record["birth_country"] == "":
            record["birth_country"] = None

        record["death_country"] = personregister[personid]["death_country"]
        if record["death_country"] == "":
            record["death_country"] = None

        if personregister[personid]["isMDB"] == True:
            record["isMDB"] = True
        else:
            record["isMDB"] = False

        records.append(record)

    make_index = client.collections[COLLECTION_NAME].documents.import_(records)
    print("indexed amount persons: ", len(records))
    print(make_index)
    print(f"done with indexing {COLLECTION_NAME}")
