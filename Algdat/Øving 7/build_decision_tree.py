#!/usr/bin/python3
# coding=utf-8
import itertools
import random
import math


# De lokale testene består av to deler. Et sett med hardkodete
# instanser som kan ses lengre nede, og muligheten for å generere
# tilfeldig instanser. Genereringen av de tilfeldige instansene
# kontrolleres ved å juste på verdiene under.

# Kontrollerer om det genereres tilfeldige instanser.
generate_random_tests = True
# Antall tilfeldige tester som genereres
random_tests = 10
# Lavest mulig antall utfall.
n_lower = 3
# Høyest mulig antall utfall.
# NB: Generering av instanser tar lang tid om denne verdien settes høyt (>25)
n_upper = 8
# Om denne verdien er 0 vil det genereres nye instanser hver gang.
# Om den er satt til et annet tall vil de samme instansene genereres
# hver gang, om verdiene over ikke endres.
seed = 0


def build_decision_tree(decisions):
    sorted_decisions = sorted(decisions, key=lambda x: x[1], reverse=True)
    leaf_nodes = {d[0]: "" for d in sorted_decisions}
    return leaf_nodes



# Hardkodete tester på formatet:
# decisions, gjennomsnittlig antall spørsmål i optimal løsning
tests = [
    ([("a", 0.5), ("b", 0.5)], 1),
    ([("a", 0.99), ("b", 0.01)], 1),
    ([("a", 0.5), ("b", 0.25), ("c", 0.25)], 1.5),
    ([("a", 0.33), ("b", 0.33), ("c", 0.34)], 1.66),
    ([("a", 0.25), ("b", 0.25), ("c", 0.25), ("d", 0.25)], 2),
    ([("a", 0.4), ("b", 0.2), ("c", 0.2), ("d", 0.2)], 2),
    ([("a", 0.3), ("b", 0.25), ("c", 0.25), ("d", 0.2)], 2),
    ([("a", 0.3), ("b", 0.2), ("c", 0.2), ("d", 0.2), ("e", 0.1)], 2.3),
]


def bruteforce_gen(n, sol={1: set([(0,)])}):
    if n in sol:
        return sol[n]

    solutions = set()
    for x in range(1, n//2 + 1):
        y = n - x
        for X in bruteforce_gen(x):
            for Y in bruteforce_gen(y):
                solutions.add(tuple(1+a for a in sorted(X+Y)))

    sol[n] = solutions
    return solutions


# Veldig treg bruteforce løsning
def bruteforce_solve(decisions):
    z = sorted(decisions, key=lambda x: x[1], reverse=True)
    return min(
        sum(a*b[1] for a,b in zip(p, z))
        for p in bruteforce_gen(len(decisions))
    )


def check_overlap_and_add_to_tree(tree, value):
    is_valid = len(tree) == 0
    for v in value:
        if v in tree:
            tree = tree[v]
        else:
            if len(tree) == 0 and not is_valid:
                return False
            tree[v] = {}
            tree = tree[v]
            is_valid = True

    return is_valid


def gen_examples(k, nl, nu):
    for _ in range(k):
        n = random.randint(max(2, nl), nu)
        decisions = set()
        while len(decisions) < n:
            decisions.add(
                "".join(random.choices("abcdefghijklmnopqrstuvwxyz",
                                       k=math.ceil(math.log(n, 26)) + 1))
            )
        prob = [random.randint(1, 10*n) for _ in range(n)]
        scale = sum(prob)
        decisions = [(a, b/scale) for a,b in zip(decisions, prob)]
        yield decisions, bruteforce_solve(decisions)


if generate_random_tests:
    if seed:
        random.seed(seed)
    tests += list(gen_examples(random_tests, n_lower, n_upper))


def test_answer(student, test_case, correct_answer):
    feedback = f"""
Koden feilet for følgende input:
decisions:
{chr(10).join(x + ': ' + str(y) for x,y in test_case)}

Ditt svar: {student}
Feedback:
"""

    if not isinstance(student, dict):
        feedback += "Funksjonen skal returnere en oppslagstabell (dictionary)."
        print(feedback)
        return True

    tree = {}
    expectance = 0
    for value, prob in test_case:
        if value not in student:
            feedback += "Beslutningen {:} er ikke med i treet.".format(value)
            print(feedback)
            return True

        encoding = student[value]
        if not isinstance(encoding, str) or not set(encoding) <= {"1", "0"}:
            feedback += (
                "Hver beslutning skal ha en streng av nuller og "
                + "enere knyttet til seg. "
            )
            print(feedback)
            return True

        if not check_overlap_and_add_to_tree(tree, encoding):
            feedback += "En av beslutningene er en internnode."
            print(feedback)
            return True

        expectance += prob * len(encoding)

    if expectance > correct_answer + 0.0000001:
        feedback += (
            "Beslutningstreet ditt er ikke optimalt. Det skulle "
            + "hatt en forventning på {:}".format(correct_answer)
            + " spørsmål, men har en forventning på "
            + str(expectance)
        )
        print(feedback)
        return True

    return False


failed = False
for test_case, answer in tests:
    student = build_decision_tree(test_case)
    failed &= test_answer(student, test_case, answer)

if not failed:
    print("Koden din fungerte for alle eksempeltestene")