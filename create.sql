create sequence kabenyk_st.seq_for_regions
    minvalue 1
    maxvalue 999999
    start with 1
    increment by 1;
create sequence kabenyk_st.seq_for_towns
    minvalue 1
    maxvalue 999999
    start with 1
    increment by 1;
create sequence kabenyk_st.seq_for_organizations
    minvalue 1
    maxvalue 999999
    start with 1
    increment by 1;
create sequence kabenyk_st.seq_for_hospital_type
    minvalue 1
    maxvalue 999999
    start with 1
    increment by 1;
create sequence kabenyk_st.seq_for_hospital_availability
    minvalue 1
    maxvalue 999999
    start with 1
    increment by 1;
create sequence kabenyk_st.seq_for_hospitals
    minvalue 1
    maxvalue 999999
    start with 1
    increment by 1;
create sequence kabenyk_st.seq_for_working_time
    minvalue 1
    maxvalue 999999
    start with 1
    increment by 1;
create sequence kabenyk_st.seq_for_doctors
    minvalue 1
    maxvalue 999999
    start with 1
    increment by 1;
create sequence kabenyk_st.seq_for_sex
    minvalue 1
    maxvalue 999999
    start with 1
    increment by 1;
create sequence kabenyk_st.seq_for_specializations
    minvalue 1
    maxvalue 999999
    start with 1
    increment by 1;
create sequence kabenyk_st.seq_for_ticket_flags
    minvalue 1
    maxvalue 999999
    start with 1
    increment by 1;
create sequence kabenyk_st.seq_for_tickets
    minvalue 1
    maxvalue 999999
    start with 1
    increment by 1;
create sequence kabenyk_st.seq_for_accounts
    minvalue 1
    maxvalue 999999
    start with 1
    increment by 1;
create sequence kabenyk_st.seq_for_patients
    minvalue 1
    maxvalue 999999
    start with 1
    increment by 1;
create sequence kabenyk_st.seq_for_journal_record_status
    minvalue 1
    maxvalue 999999
    start with 1
    increment by 1;
create sequence kabenyk_st.seq_for_patients_journals
    minvalue 1
    maxvalue 999999
    start with 1
    increment by 1;

create table kabenyk_st.regions(
    id_region number default kabenyk_st.seq_for_regions.nextval primary key,
    name varchar2(100) not null
);
create table kabenyk_st.towns(
    id_town number default kabenyk_st.seq_for_towns.nextval primary key,
    name varchar2(100) not null,
    id_region number references kabenyk_st.regions (id_region)
);
create table kabenyk_st.organizations(
    id_organization number default kabenyk_st.seq_for_organizations.nextval primary key,
    name varchar2(100) not null,
    id_town number references kabenyk_st.towns (id_town)
);
create table kabenyk_st.hospital_type(
    id_hospital_type number default kabenyk_st.seq_for_hospital_type.nextval primary key,
    type varchar2(20) not null
);
create table kabenyk_st.hospital_availability(
    id_hospital_availability number default kabenyk_st.seq_for_hospital_availability.nextval primary key,
    availability varchar2(10) not null
);
create table kabenyk_st.hospitals(
    id_hospital number default kabenyk_st.seq_for_hospitals.nextval primary key,
    name varchar2(100) not null,
    id_hospital_availability number references kabenyk_st.hospital_availability (id_hospital_availability),
    id_hospital_type number references kabenyk_st.hospital_type (id_hospital_type),
    id_organization number references kabenyk_st.organizations (id_organization),
    data_of_record_deletion date
);
create table kabenyk_st.working_time(
    id_time number default kabenyk_st.seq_for_working_time.nextval primary key,
    day varchar2(100) not null,
    begin_time varchar2(5) not null,
    end_time varchar2(5) not null,
    id_hospital number references kabenyk_st.hospitals (id_hospital),
    data_of_record_deletion date
);
create table kabenyk_st.doctors(
    id_doctor number default kabenyk_st.seq_for_doctors.nextval primary key,
    id_hospital number references kabenyk_st.hospitals (id_hospital),
    surname varchar2(100) not null,
    name varchar2(100) not null,
    patronymic varchar2(100) not null,
    area number not null,
    qualifications varchar2(100) not null,
    data_of_record_deletion date
);
create table kabenyk_st.sex(
    id_sex number default kabenyk_st.seq_for_sex.nextval primary key,
    sex varchar2(100) not null
);
create table kabenyk_st.specializations(
    id_specialization number default kabenyk_st.seq_for_specializations.nextval primary key,
    specialization varchar2(100) not null,
    min_age number not null,
    max_age number not null,
    id_sex number references kabenyk_st.sex(id_sex),
    data_of_record_deletion date
);
create table kabenyk_st.doctors_specializations(
    id_doctor number,
    id_specialization number,
    primary key (id_doctor, id_specialization),
    foreign key (id_doctor) references kabenyk_st.doctors (id_doctor),
    foreign key (id_specialization) references kabenyk_st.specializations (id_specialization),
    data_of_record_deletion date
);
create table kabenyk_st.ticket_flags(
    id_ticket_flag number default kabenyk_st.seq_for_ticket_flags.nextval primary key,
    flag varchar2(10) not null
);
create table kabenyk_st.tickets(
    id_ticket number default kabenyk_st.seq_for_tickets.nextval primary key,
    id_ticket_flag number references kabenyk_st.ticket_flags (id_ticket_flag),
    begin_time date not null,
    end_time date not null,
    id_doctor number references kabenyk_st.doctors (id_doctor),
    data_of_record_deletion date
);
create table kabenyk_st.accounts(
    id_account number default kabenyk_st.seq_for_accounts.nextval primary key,
    name varchar2(100) not null
);
create table kabenyk_st.patients(
    id_patient number default kabenyk_st.seq_for_patients.nextval primary key,
    surname varchar2(100) not null,
    name varchar2(100) not null,
    patronymic varchar2(100),
    date_of_birth date not null,
    medical_polis_number varchar2(16) not null ,
    passport_series_and_number varchar2(10),
    snils_number varchar2(11),
    id_sex number references kabenyk_st.sex (id_sex),
    phone number(11),
    area number not null,
    id_account number references kabenyk_st.accounts (id_account)
);
create table kabenyk_st.journal_record_status(
    id_journal_record_status number default kabenyk_st.seq_for_journal_record_status.nextval primary key,
    status varchar2(100) not null
);
create table kabenyk_st.patients_journals(
    id_journal number default kabenyk_st.seq_for_patients_journals.nextval primary key,
    id_journal_record_status number references kabenyk_st.journal_record_status (id_journal_record_status),
    day_time date not null,
    id_patient number references kabenyk_st.patients (id_patient),
    id_ticket number references kabenyk_st.tickets (id_ticket),
    data_of_record_deletion date
);
