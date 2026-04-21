from tabulate import tabulate
from datetime import timedelta

print("\nWelcome to StudySwift!")
def make_table(subjects_and_lengths, header):
  table = tabulate(subjects_and_lengths.items(), headers=header, tablefmt="fancy_grid")
  return table


# To enter subjects and its lengths
def add_subjects(num_subjects):
  for i in range(num_subjects):
    if num_subjects > 1:
      print(f"Please enter the name of your subject (subject number {i + 1}):")
    else:
      print("Please enter the name of your subject:")

    subject = input("> ").title()
    if len(subject) == 2:
      subject = subject.upper()

    while subject not in file:
      print("Please enter a valid subject.")
      subject = input("> ").title()
      if len(subject) == 2:
        subject = subject.upper()

    print(f"Please enter how many hours you would like to study {subject} for a week:")
    print("(Maximum 15 hours per subject)")
    length = input("> ")

    while length.isdigit() == False:
      length = input("Please enter a number.\n> ")

    while int(length) > 15:
      print("Please do not enter hours over 15.")
      length = input("> ")

    subjects_and_lengths[subject] = int(length)
  table = make_table(subjects_and_lengths, header)
  print(table)


# To do List
# To edit the table
def edit():
  edit_or_quit = input("Type 'c' to change or 'q' to quit:\n> ").upper()
  while edit_or_quit != 'Q':

    add_or_remove = input("Type 'a' to add a subject, 'r' to remove or 'e' to edit:\n> ").upper()

    if add_or_remove == 'A':
      add_subjects(1)

    elif add_or_remove == 'R':
      print("Please enter the subject that would you like to remove:")
      subject = input("> ").title()
      if len(subject) == 2:
        subject = subject.upper()

      while subject not in subjects_and_lengths:
        print(f"{subject} does not exist within your study plan.")
        subject = input("> ").title()
        if len(subject) == 2:
          subject = subject.upper()

      del subjects_and_lengths[subject]


    elif add_or_remove == 'E':
      print("Which of the following subject hours would you like to edit:")
      for subject in subjects_and_lengths:
        print(f"- {subject}: {subjects_and_lengths[subject]} hours.")

      edit = input("> ").title()
      if len(edit) == 2:
        edit = edit.upper()

      if edit in subjects_and_lengths:
        print("New hours:")
        new_hours = input("> ")

        while new_hours.isdigit() == False:
          print("Please enter a number.")
          new_hours = input("> ")

      new_hours = int(new_hours)
      subjects_and_lengths[edit] = new_hours
      table = make_table(subjects_and_lengths, header)
      print(table)

    else:
      print("Please enter 'a' to add, 'r' to read or 'e' to edit.")
    edit_or_quit = input("Type 'c' to change or 'q' to quit:\n> ").upper()
  table = make_table(subjects_and_lengths, header)
  print(table)


# tasks_function()
##

print("Please enter how many subjects you'd like to create your study plan for (1-10):")
num_subjects = input("> ")

while True:
  try:
    if int(num_subjects) > 10:
      print("Please enter less than 10 subjects.")
      num_subjects = input("> ")
    elif int(num_subjects) < 1:
      print("Please enter at least 1 subject.")
      num_subjects = input("> ")
    else:
      break
  except ValueError:
    num_subjects = input("Please enter integers.\n> ")
    continue

num_subjects = int(num_subjects)
header = ["Subject", "Hours"]

subjects_and_lengths = {}

contents = open('subjects.txt', 'r')
file = []
for line in contents:
  if "" == line or '\n' == line:
    continue
  if "\n" in line:
    file.append(line[:-1])
  else:
    file.append(line)

add_subjects(num_subjects)
edit()


##

def validate():
  while True:
    time = input("> ")

    if time[:2].isdigit() == False or (time[3:].upper() != "AM" and time[3:].upper() != "PM"):
      print("Invalid format.")
      print("Please make sure if you have entered a single digit hour you put a '0' before it.\ni.e. 7 PM = 07 PM.")
      continue

    elif time[:2].isdigit() and int(time[:2]) > 12:
      print("Invalid format.")
      print("Please make sure if you have entered a single digit hour you put a '0' before it.\ni.e. 7 PM = 07 PM.")
      continue

    if time[3:].upper() == "AM" and time[:2] == "12":
      return "00"

    if time[3:].upper() == "PM" and time[:2] < "12":
      return str(int(time[:2]) + 12)

    if time[3:].upper() == "AM" or (time[:2] == "12" and time[3:].upper() == "PM"):
      return time[:2]


def get_time():
  cont = True
  while cont:
    start, end = 0, 0
    while (end - start) < 1 or (end - start) > 15 or (end < start):
      print("\nPlease make sure the difference between start and end is 1-15 hours.")
      print("Make sure the end time does not go into the following day.")
      print("\nPlease enter start time.")
      print("i.e. '10 PM' or '07 AM'")
      start = int(validate())

      print("Please enter end time.")
      end = int(validate())

    return start, end


def create_week():
  while True:
    week = {
      "Monday": 0,
      "Tuesday": 0,
      "Wednesday": 0,
      "Thursday": 0,
      "Friday": 0,
      "Saturday": 0,
      "Sunday": 0
    }

    for day in week:
      print(f"\nWhat times are you free on {day} to study?")
      skip = input("Type 's' to skip this day and ENTER to continue: ").upper()
      if skip != "S":
        print("\nRunning program...")
        start, end = get_time()
        week[day] = [start, end]
      else:
        print("\nSkipping...")

    total_studying_time = 0
    for term in subjects_and_lengths:
      total_studying_time += subjects_and_lengths[term]

    new_week = {}

    for day in week:
      if week[day] != 0:
        new_week[day] = week[day]
    available_hours = 0
    for day in new_week:
      available_hours += (new_week[day][1] - new_week[day][0])

    print("Total available hours:", available_hours)
    print("Total studying hours:", total_studying_time)

    if available_hours < total_studying_time:
      print("Not enough available time to cover studying hours.")
      continue
    else:
      break
  return new_week, total_studying_time, available_hours


temp_week, temp_studying_time, available_hours = create_week()

week_hours = {}

for value in temp_week:
  week_hours[value] = 0

for available in temp_week:
  week_hours[available] = temp_week[available][1] - temp_week[available][0]

# print(week_hours)  # days studying with number of hours free
# print(temp_week)  # days studying with time gap free
# print(subjects_and_lengths)  # subjects and how long they need to be studied

# https://replit.com/join/pfqvneloae-rayyanhussain7
# What can I do?


workeachday = [(week_hours[hours] * (temp_studying_time / available_hours)) for hours in week_hours]
hourspersub = [(subjects_and_lengths[hours]) for hours in subjects_and_lengths]
# print(workeachday)
# print(hourspersub)


subject = 0
day = 0
days = len(week_hours.values())

subject_list = list(subjects_and_lengths.keys())

final_table = {}

time_table = []

available_hours = list(temp_week.values())
start_list = []

new_day = True

for i in available_hours:
  start_list.append(i[0])


def timetable():
  global day, days, subject, time_table, start_list, start_time, end_time, new_day
  if day == days:
    return
  available_days = list(week_hours.keys())
  day_used = available_days[day]
  # final_table[subject_list[subject]]
  try:
    if new_day:
      start_time = start_list[day]
    else:
      start_time = end_time

    if workeachday[day] <= hourspersub[subject]:
      end_time = start_time + workeachday[day]
      time_diff = workeachday[day]
    else:
      end_time = start_time + hourspersub[subject]
      time_diff = hourspersub[subject]
    if time_diff >= 15/60:

      end_hours = int(end_time)
      end_minutes = int((end_time * 60) % 60)

      start_hours = int(start_time)
      start_minutes = int((start_time * 60) % 60)

      converted_start = "%02d:%02d" % (start_hours, 5 * round(start_minutes/5))
      converted_end = "%02d:%02d" % (end_hours, 5 * round(end_minutes/5))

      if len(str(start_time)) == 2:
        time_period = f"{start_time}:00-{converted_end}"
      else:
        time_period = f"{converted_start}-{converted_end}"

      each_subject = subject_list[subject]
      time_table.append([day_used, each_subject, time_period])

    if workeachday[day] < hourspersub[subject]:
      hourspersub[subject] -= workeachday[day]
      day += 1
      new_day = True

    elif workeachday[day] == hourspersub[subject]:
      hourspersub[subject] -= workeachday[day]
      subject += 1
      day += 1
      new_day = True
    else:
      workeachday[day] -= hourspersub[subject]
      subject += 1
      new_day = False
  except:
    day += 1
    new_day = True
  timetable()


timetable()

headers = ["Day", "Subject", "Time"]
print("Revise the following using the 'Pomodoro' studying method (25 min studying / 5 min break)")
print(tabulate(time_table, headers=headers, tablefmt="fancy_grid"))

input()