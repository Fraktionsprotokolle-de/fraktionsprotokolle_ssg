import glob
import os
import datetime
import locale
import sqlite3
import time
import sys
import json

from typesense.api_call import ObjectNotFound
from acdh_cfts_pyutils import TYPESENSE_CLIENT as client
# from acdh_cfts_pyutils import CFTS_COLLECTION
from acdh_tei_pyutils.tei import TeiReader
from acdh_tei_pyutils.utils import (
    extract_fulltext,
    get_xmlid,
    make_entity_label,
    check_for_hash,
)
from tqdm import tqdm

from sentence_transformers import SentenceTransformer

from person_index import CreatePersonIndex, Person

from dotenv import load_dotenv

records = []


def get_person_label(personid):
    global c
    personid = personid.replace("#", "")

    label = None
    # Query to list all tables
#    query = "SELECT reg FROM persons WHERE id = '" + str(personid) + "';"

 #   c.execute(query)
  #  result = c.fetchone()
    try:
        result = person_dict[personid]["reg"]
        label = result
        if label != "" and personid not in person_found:
            person_found.append(personid)
        return label
    except IndexError:
        return ""
    except KeyError:
        return ""
    except:
        sys.exit("Error with" + personid)


def get_persons_from_db():
    global c
    person_dict = {}
    query = "SELECT id, reg, forename, surname, letter, gnd, birth_date, death_date, isMDB, Found, birth_place, death_place, birth_country, death_country FROM persons;"
    c.execute(query)
    result = c.fetchall()

    for row in result:
        id = ""
        id = row[0]
        person_dict[id] = {}
        person_dict[id]["id"] = id
        person_dict[id]["forename"] = row[2]
        person_dict[id]["surname"] = row[3]
        person_dict[row[0]]["reg"] = row[1]
        person_dict[row[0]]["sex"] = row[4]
        person_dict[row[0]]["gnd"] = row[5]
        person_dict[row[0]]["birth"] = row[6]
        person_dict[row[0]]["death"] = row[7]
        person_dict[row[0]]["isMDB"] = row[8]
        person_dict[row[0]]["letter"] = row[4]
        person_dict[row[0]]["found"] = row[9]
        person_dict[row[0]]["birth_place"] = row[10]
        person_dict[row[0]]["death_place"] = row[11]
        person_dict[row[0]]["birth_country"] = row[12]
        person_dict[row[0]]["death_country"] = row[13]
    return person_dict


def get_vectors(text):
    return model.encode(text)[0].tolist()


def load_synonyms(collection_name):
    """Load synonyms from ./data/synonyms/*.jsonl files into Typesense collection"""
    synonym_files = glob.glob("./data/synonyms/*.jsonl")

    if not synonym_files:
        print("No synonym files found in ./data/synonyms/")
        return

    print(f"Loading synonyms for collection: {collection_name}")

    for synonym_file in synonym_files:
        print(f"Processing synonym file: {synonym_file}")
        with open(synonym_file, 'r', encoding='utf-8') as f:
            for line in f:
                if line.strip():
                    try:
                        synonym_data = json.loads(line)
                        # Upload synonym to Typesense
                        client.collections[collection_name].synonyms.upsert(
                            synonym_data['id'],
                            {
                                'synonyms': synonym_data['synonyms']
                            }
                        )
                    except json.JSONDecodeError as e:
                        print(f"Error parsing JSON line: {e}")
                    except Exception as e:
                        print(f"Error uploading synonym {
                              synonym_data.get('id', 'unknown')}: {e}")

    print(f"Finished loading synonyms for {collection_name}")


def make_index_introduction(introductions, COLLECTION_EINLEITUNG_NAME):
    records = []
    for x in tqdm(introductions, total=len(introductions)):
        cfts_record = {
            "project": COLLECTION_EINLEITUNG_NAME,
        }
        record = {}
        doc = TeiReader(x)
        try:
            body = doc.any_xpath(".//tei:body")[0]
            record["id"] = os.path.split(x)[-1].replace(".xml", "")
            # cfts_record["id"] = record["id"]
            print(record["id"])
        except IndexError:
            print("Index-Error on document " + x)


        record["rec_id"] = os.path.split(x)[-1]
        # cfts_record["rec_id"] = record["rec_id"]

        try:
            record["title"] = extract_fulltext(
                doc.any_xpath('.//tei:titleStmt/tei:title[@level="a"]')[0]
            )

        except Exception as e:
            print(f"title issues in {x}, due to: {e}")
            record["title"] = "Kein Titel"


        record["persons"] = set()
        try:
            for y in doc.any_xpath(".//tei:text//tei:name[@type='Person']"):
                id = y.xpath("@ref")[0]
                label = get_person_label(str(id))

                # check if id contains BrandtWilly_1949-09-07
        #        if not str(id) in person_found:
                if label != "":
                    record["persons"].add(label)

        # cfts_record["persons"] = [x["label"] for x in record["persons"]]
        except IndexError:
            print("Error found at " + record["id"])

        # Convert set back to list
        record["persons"] = list(record["persons"])

        record["orgs"] = []
        for y in doc.any_xpath(".//tei:text//tei:org[@xml:id]"):
            try:
                if y:
                    item = {"id": y.xpath(
                        "@ref")[0], "label": make_entity_label(y.xpath("./*[1]")[0])[0]}
                    record["orgs"].append(item)
            except IndexError:

                print("IndexError at " + record["id"])
                print(y)

        record["full_text"] = f"{extract_fulltext(
            body)} {record['title']}".replace("(", " ")

        record["items"] = []
        for y in doc.any_xpath('.//tei:text/tei:body//tei:div'):
            try:
                name = y.xpath("./@type")
                link = y.xpath("./@xml:id")
                if name and link:
                    item = {
                        "name": name[0].strip(),
                        "link": link[0]
                    }
                    record["items"].append(item)
            except IndexError:
                print("IndexError at " + record["id"])
                print(y)
        # cfts_record["full_text"] = record["full_text"]
        records.append(record)
        # cfts_records.append(cfts_record)

        # Create Vectors
        sentences = [record["full_text"]] + record["persons"] + record["orgs"]

        # check if sentences are not empty
        if len(sentences) == 0 or sentences == [""]:
            record["vectors"] = []
        else:
            # record["vectors"] = []
            record["vectors"] = get_vectors(sentences)
        # cfts_record["vectors"] = record["vectors"]
        records.append(record)
    return records


def make_index_protocol(files, COLLECTION_NAME):
    records = []
    print("Making index for protocol files")

    print(f"Total files to process: {len(files)}")
    for x in tqdm(files, total=len(files)):
        cfts_record = {
            "project": COLLECTION_NAME,
        }
        record = {}
        doc = TeiReader(x)
        try:
            body = doc.any_xpath(".//tei:body")[0]
            record["id"] = os.path.split(x)[-1].replace(".xml", "")
            # cfts_record["id"] = record["id"]
            print(record["id"])
        except IndexError:
            print("Index-Error on document " + x)

        # cfts_record["resolver"] = (
        #    f"https://www.fraktionsprotokolle.de/{record['id']}.html"
        # )
        record["rec_id"] = os.path.split(x)[-1]
        # cfts_record["rec_id"] = record["rec_id"]

        # check if xml:id of category is not "EINL"
        try:
            if doc.any_xpath(
                '//tei:category[@xml:id="EINL"]'
            )[0] is not None:
                continue
        except IndexError:
            pass

        try:
            record["title"] = extract_fulltext(
                doc.any_xpath('.//tei:titleStmt/tei:title[@level="a"]')[0]
            )
        except Exception as e:
            print(f"title issues in {x}, due to: {e}")
            record["title"] = "Kein Titel"

        # cfts_record["title"] = record["title"]

        try:
            record["party"] = doc.any_xpath(
                '//tei:profileDesc//tei:idno[@type="Fraktion-Landesgruppe"]'
            )[0].text
            # cfts_record["party"] = record["party"]
        except IndexError:
            record["party"] = "Keine Fraktion"
            # cfts_record["party"] = record["party"]

        try:
            record["period"] = doc.any_xpath(
                '//tei:profileDesc//tei:idno[@type="wp"]'
            )[0].text
            cfts_record["period"] = record["period"]
        except IndexError:
            record["period"] = "Keine Wahlperiode"
            # cfts_record["period"] = record["period"]

        try:
            date_str = doc.any_xpath(
                '//tei:profileDesc//tei:creation/tei:date/@when'
            )[0]
        except IndexError:
            date_str = MIN_DATE

        # if date_str is MIN_DATE, try to get from date because of multiple dates
        if date_str == MIN_DATE:
            try:
                date_str = doc.any_xpath(
                    '//tei:profileDesc//tei:creation/tei:date[1]/@from'
                )[0]
            except IndexError:
                date_str = MIN_DATE

        try:
            record["date"] = date_str
            # cfts_record["date"] = date_str
        except ValueError:
            pass

        try:
            record["year"] = int(date_str[:4])
            # cfts_record["year"] = date_str[:4]
        except ValueError:
            pass

        record["persons"] = set()
        try:
            for y in doc.any_xpath(".//tei:text//tei:name[@type='Person']"):
                id = y.xpath("@ref")[0]
                label = get_person_label(str(id))

                # check if id contains BrandtWilly_1949-09-07
        #        if not str(id) in person_found:
                if label != "":
                    record["persons"].add(label)

        # cfts_record["persons"] = [x["label"] for x in record["persons"]]
        except IndexError:
            print("Error found at " + record["id"])

        # Convert set back to list
        record["persons"] = list(record["persons"])

        record["orgs"] = []
        for y in doc.any_xpath(".//tei:text//tei:org[@xml:id]"):
            try:
                if y:
                    item = {"id": y.xpath(
                        "@ref")[0], "label": make_entity_label(y.xpath("./*[1]")[0])[0]}
                    record["orgs"].append(item)
            except IndexError:

                print("IndexError at " + record["id"])
                print(y)

        record["full_text"] = f"{extract_fulltext(
            body)} {record['title']}".replace("(", " ")

        record["items"] = []
        for y in doc.any_xpath('.//tei:text/tei:front//tei:list[@type="SVP"]//tei:item'):
            try:
                name = y.xpath("./text()")
                link = y.xpath("./@corresp")
                if name and link:
                    item = {
                        "name": name[0].strip(),
                        "link": link[0]
                    }
                    record["items"].append(item)
            except IndexError:
                print("IndexError at " + record["id"])
                print(y)
        # cfts_record["full_text"] = record["full_text"]
        records.append(record)
        # cfts_records.append(cfts_record)

        # Create Vectors
        sentences = [record["full_text"]] + record["persons"] + record["orgs"]

        # check if sentences are not empty
        if len(sentences) == 0 or sentences == [""]:
            record["vectors"] = []
        else:
            # record["vectors"] = []
            record["vectors"] = get_vectors(sentences)
        # cfts_record["vectors"] = record["vectors"]
        records.append(record)
    return records


locale.setlocale(category=locale.LC_ALL, locale="de_DE.UTF-8")

nsmap = {
    "tei": "http://www.tei-c.org/ns/1.0",
    "xml": "http://www.w3.org/XML/1998/namespace",
}

# Load the .env file
load_dotenv()

files = glob.glob("./data/editions/*.xml")
introductions = glob.glob("./data/einleitungen/*.xml")

COLLECTION_NAME = "kgparl"
COLLECTION_EINLEITUNG_NAME = "kgparl_einleitung"
MIN_DATE = "1949"


person_dict = {}
person_found = []
model = SentenceTransformer('sentence-transformers/all-MiniLM-L12-v2')
db_path = "/Users/stephan/Documents/Arbeit/Selbstständig/KGParl/fraktionsprotokolle-static/golang/persons.db"

try:
    conn = sqlite3.connect(db_path)
    c = conn.cursor()
    print("Database connected successfully.")
except sqlite3.Error as e:
    print(f"Error connecting to {db_path}: {e}")
    exit()


person_dict = get_persons_from_db()
print("person_dict loaded with " + str(len(person_dict)) + " entries")


try:
    client.collections[COLLECTION_NAME].delete()
    client.collections[COLLECTION_EINLEITUNG_NAME].delete()
    print("Collections deleted")
except ObjectNotFound:
    pass

# Initialize PersonDict
# person_dict = createPersonDict()

current_schema = {
    "name": COLLECTION_NAME,
    "enable_nested_fields": True,
    "fields": [
        {"name": "id", "type": "string"},
        {"name": "rec_id", "type": "string", "facet": True, "optional": False},
        {"name": "title", "type": "string"},
        {"name": "full_text", "type": "string"},
        {"name": "party", "type": "string", "facet": True,
            "optional": False, "sort": True, "index": True},
        {"name": "period", "type": "string", "facet": True,
            "optional": False, "sort": True, "index": True},
        {"name": "date", "type": "string", "sort": True},
        {
            "name": "year",
            "type": "int32",
            "optional": False,
            "facet": True,
            "sort": True,
        },
        {
            "name": "persons",
            "type": "string[]",
            "facet": True,
            "optional": True,
            # "fields" : [
            #   {
            #       "name":"id",
            #       "type": "string"
            #   },
            #   {
            #       "name":"label",
            #       "type": "string"
            #   }
            # ]
        },
        {
            "name": "orgs",
            "type": "string[]",
            "facet": True,
            "optional": True,
        },
        {
            "name": "items",
            "type": "object[]",
            "optional": True,
            "fields": [
                {
                    "name": "name",
                    "type": "string"
                },
                {
                    "name": "link",
                    "type": "string"
                }
            ]
        }
    ],
    "default_sorting_field": "year",
}

current_schema_einleitung = {
    "name": COLLECTION_EINLEITUNG_NAME,
    "enable_nested_fields": True,
    "fields": [
        {"name": "id", "type": "string"},
        {"name": "rec_id", "type": "string", "facet": True, "optional": False},
        {"name": "title", "type": "string", "sort": True},
        {"name": "full_text", "type": "string"},
        {
            "name": "persons",
            "type": "string[]",
            "facet": True,
            "optional": True,
            # "fields" : [
            #   {
            #       "name":"id",
            #       "type": "string"
            #   },
            #   {
            #       "name":"label",
            #       "type": "string"
            #   }
            # ]
        },
    ],
    "default_sorting_field": "title",
}

# Create additional virtual Indices
try:
    client.collections[COLLECTION_NAME].delete()
except ObjectNotFound:
    pass


try:
    client.collections[COLLECTION_EINLEITUNG_NAME].delete()
except ObjectNotFound:
    pass

client.collections.create(current_schema)
client.collections.create(current_schema_einleitung)

# Load synonyms into the collection
load_synonyms(COLLECTION_NAME)
load_synonyms(COLLECTION_EINLEITUNG_NAME)

# Protokolle
print(f"Starting indexing {COLLECTION_NAME}")
records = make_index_protocol(files, COLLECTION_NAME)
make_index = client.collections[COLLECTION_NAME].documents.import_(records)
print(f"done with indexing {COLLECTION_NAME}")

# Einleitungen
records_einleitung = make_index_introduction(
    introductions, COLLECTION_EINLEITUNG_NAME)
print(f"Starting indexing {COLLECTION_EINLEITUNG_NAME}")
make_index_einleitung = client.collections[COLLECTION_EINLEITUNG_NAME].documents.import_(records_einleitung)
print(f"done with indexing {COLLECTION_EINLEITUNG_NAME}")

print(f"Starting PersonIndex")
# get all persons from db
print("current persons found: " + str(len(person_found)))
CreatePersonIndex(person_dict, person_found)
print(f"done with PersonIndex")

# close connctions
c.close()
conn.close()
