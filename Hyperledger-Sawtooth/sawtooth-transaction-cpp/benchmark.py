#!/usr/bin/env python3


import subprocess
import datetime
import time
import pathlib
import os
##################### CONFIG #####################
RANCHER_BEARER_TOKEN = os.environ.get('RANCHER_BEARER_TOKEN')
if RANCHER_BEARER_TOKEN == None:
    print("ERROR: Missing RANCHER_BEARER_TOKEN environement variable !")
    quit()

file_sender_log = "sender_log.log"
file_stats_log = "stats_log.log"

# config doc: https://sawtooth.hyperledger.org/docs/pbft/nightly/master/configuring-pbft.html
test_profiles = [
    # {  # basic test first
    #     "sender_parameters": {
    #         "limit": "100",
    #         "js_nb_parallele": "3",
    #         "js_wait_time": "1"
    #     }
    # },
    {
        "sender_parameters": {
            "limit": "10000",
            "js_nb_parallele": "5",
            "js_wait_time": "1"
        }
    },
    {
        "sender_parameters": {
            "limit": "10000",
            "js_nb_parallele": "10",
            "js_wait_time": "1"
        }
    },
    {
        "sender_parameters": {
            "limit": "10000",
            "js_nb_parallele": "20",
            "js_wait_time": "1"
        }
    },
    {
        "sender_parameters": {
            "limit": "10000",
            "js_nb_parallele": "30",
            "js_wait_time": "1"
        }
    },
    {
        "sender_parameters": {
            "limit": "10000",
            "js_nb_parallele": "40",
            "js_wait_time": "1"
        }
    },
    {
        "sender_parameters": {
            "limit": "10000",
            "js_nb_parallele": "50",
            "js_wait_time": "1"
        }
    },
    {
        "sender_parameters": {
            "limit": "10000",
            "js_nb_parallele": "60",
            "js_wait_time": "1"
        }
    },
    # {
    #     "sender_parameters": {
    #         "limit": "10000",
    #         "js_nb_parallele": "70",
    #         "js_wait_time": "1"
    #     }
    # },
    # {
    #     "sender_parameters": {
    #         "limit": "10000",
    #         "js_nb_parallele": "80",
    #         "js_wait_time": "1"
    #     }
    # },
    # {
    #     "sender_parameters": {
    #         "limit": "10000",
    #         "js_nb_parallele": "90",
    #         "js_wait_time": "1"
    #     }
    # },
    # {
    #     "sender_parameters": {
    #         "limit": "10000",
    #         "js_nb_parallele": "100",
    #         "js_wait_time": "1"
    #     }
    # },
]
##################### DEF GENERAL #####################


def log(_str, ts=True, end="\n"):
    now = datetime.datetime.now()
    if ts:
        print("{} | {}".format(now.strftime("%Y-%m-%d %H:%M:%S"), _str), end=end)
        return "{} | {}".format(now.strftime("%Y-%m-%d %H:%M:%S"), _str)
    else:
        print("{}".format(_str), end=end)
        return "{}".format(_str)


def clear_file(filename):
    text_file = open(filename, "w")
    text_file.write("")
    text_file.close()


def append_file(filename, text):
    text_file = open(filename, "a")
    text_file.write(text)
    text_file.close()


def duplicate_file(filename, newfilename):
    filedata = None
    f = open(filename, 'r')
    filedata = f.read()
    f.close()

    f = open(newfilename, 'w')
    f.write(filedata)
    f.close()


def set_file_params(filename, marker, data):
    filedata = None
    f = open(filename, 'r')
    filedata = f.read()
    f.close()

    newdata = filedata.replace(marker, data)

    f = open(filename, 'w')
    f.write(newdata)
    f.close()


##################### DEF RUN SCRIPTS #####################

def start_sender(sender_parameters, test_name):
    log("Start sender")

    log("Set parameters", end="")
    duplicate_file("docker-compose-sender.yaml",
                   "docker-compose-sender.yaml.benchmark")
    # params = "{} {} {}".format(
    #     sender_parameters["limit"], sender_parameters["js_nb_parallele"], sender_parameters["js_wait_time"])
    # set_file_params("docker-compose-sender.yaml.benchmark",
    #                 "<SENDER_TEST_OPTIONS>", params)
    # log(" OK", ts=False)

    # result = subprocess.check_output(
    #     ['docker-compose', '-f', 'docker-compose-sender.yaml.benchmark', 'up', 'sender'], stderr=subprocess.STDOUT)

    subprocess.check_output(
        ['docker-compose', '-f', 'docker-compose-sender.yaml.benchmark', 'down'], stderr=subprocess.STDOUT)

    params = "{} {} {}".format(
        sender_parameters["js_nb_parallele"], sender_parameters["js_wait_time"], sender_parameters["limit"])
    set_file_params("docker-compose-sender.yaml.benchmark",
                    "<SENDER_TEST_JS_OPTIONS>", params)
    log(" OK", ts=False)
    log(" CMD SENDER: docker-compose -f docker-compose-sender.yaml.benchmark up --no-color --quiet-pull sender-js", ts=False)
    append_file(file_sender_log,
                "\n============= {} ============\n".format(test_name))
    result = subprocess.check_output(
        ['docker-compose', '-f', 'docker-compose-sender.yaml.benchmark', 'up', '--no-color', '--quiet-pull', 'sender-js'], stderr=subprocess.STDOUT)

    log(result.decode("utf-8"), ts=False)

    # append_file(file_sender_log, result.decode("utf-8").split("Start loop")[1])
    append_file(file_sender_log, result.decode("utf-8"))
    append_file(file_sender_log,
                "\n============= END {} ============\n".format(test_name))
    log("Sleep {} sec for blockchain stabilize".format(60))
    time.sleep(60)


def start_stats(test_name):

    log("Start stats")
    working_dir = pathlib.Path(__file__).parent.absolute()
    append_file(file_stats_log, log(""))
    append_file(file_stats_log,
                "\n============= {} ============\n".format(test_name))
    with open(file_stats_log, "a") as f:
        subprocess.call(
            ['python3', 'test_links.py'], cwd=working_dir, stderr=f, stdout=f)
    append_file(file_stats_log,
                "\n============= END {} ============\n".format(test_name))

    # log("Start stats")
    # working_dir = pathlib.Path(__file__).parent.absolute()
    # result = subprocess.check_output(
    #     ['python3', 'test_links.py'], cwd=working_dir, stderr=subprocess.STDOUT)
    # log(result.decode("utf-8"), ts=False)
    # append_file(file_stats_log,
    #             "\n============= {} ============\n".format(test_name))
    # append_file(file_stats_log, result.decode("utf-8"))
    # append_file(file_stats_log,
    #             "\n============= END {} ============\n".format(test_name))
    time.sleep(1)


def reboot_blockchain():
    log("Rebooting blockchain")
    log("Login in rancher")
    working_dir = pathlib.Path(__file__).parent.absolute() / 'rancher-v2.4.10'

    subprocess.call(['bash', 'login.sh', RANCHER_BEARER_TOKEN],
                    cwd=working_dir, stderr=subprocess.STDOUT)

    subprocess.call(['bash', 'restart_blockchain.sh'],
                    cwd=working_dir, stderr=subprocess.STDOUT)

    log("Wainting for blockchain initialization (3min)")
    time.sleep(180)

    log("Rebooting blockchain Finished")

##################### MAIN #####################


def main(profiles):
    log("Start benchmark Hyperledger Sawtooth PBFT consensus")
    nb_profiles = len(profiles)
    log("Found {} benchmarks".format(nb_profiles))

    log("Clear {}".format(file_sender_log))
    clear_file(file_sender_log)
    log("Clear {}".format(file_stats_log))
    clear_file(file_stats_log)

    for i in range(nb_profiles):
        log("Benchmark n°{}".format(i))
        reboot_blockchain()

        start_sender(profiles[i]["sender_parameters"], "TEST n°{}".format(i))

        # start_stats("TEST n°{}".format(i))

    log("Finishing")

    log("Done {} benchmarks".format(nb_profiles))
    os.system('spd-say "Benchmark finished"')


# main(test_profiles)
try:
    main(test_profiles)
except Exception as e:
    print("Error: \n %s" % str(e))
