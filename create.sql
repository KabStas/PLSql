create table kabenyk_st.regions(
    id_region number generated by default as identity
        (start with 1 maxvalue 999999999 minvalue 1 nocycle nocache noorder) primary key,
    name varchar2(100) not null
);
create table kabenyk_st.towns(
    id_town number generated by default as identity
        (start with 1 maxvalue 999999999 minvalue 1 nocycle nocache noorder) primary key,
    name varchar2(100) not null,
    id_region number references kabenyk_st.regions (id_region)
);
create table kabenyk_st.organizations(
    id_organization number generated by default as identity
        (start with 1 maxvalue 999999999 minvalue 1 nocycle nocache noorder) primary key,
    name varchar2(100) not null,
    id_town number references kabenyk_st.towns (id_town)
);
create table kabenyk_st.hospital_type(
    id_hospital_type number generated by default as identity
        (start with 1 maxvalue 999999999 minvalue 1 nocycle nocache noorder) primary key,
    type varchar2(20) not null
);
create table kabenyk_st.hospital_availability(
    id_hospital_availability number generated by default as identity
        (start with 1 maxvalue 999999999 minvalue 1 nocycle nocache noorder) primary key,
    availability varchar2(10) not null
);
create table kabenyk_st.hospitals(
    id_hospital number generated by default as identity
        (start with 1 maxvalue 999999999 minvalue 1 nocycle nocache noorder) primary key,
    name varchar2(100) not null,
    id_hospital_availability number references kabenyk_st.hospital_availability (id_hospital_availability),
    id_hospital_type number references kabenyk_st.hospital_type (id_hospital_type),
    id_organization number references kabenyk_st.organizations (id_organization),
    data_of_record_deletion date
);
create table kabenyk_st.working_time(
    id_time number generated by default as identity
        (start with 1 maxvalue 999999999 minvalue 1 nocycle nocache noorder) primary key,
    day varchar2(100) not null,
    begin_time varchar2(5) not null,
    end_time varchar2(5) not null,
    id_hospital number references kabenyk_st.hospitals (id_hospital)
);
create table kabenyk_st.doctors(
    id_doctor number generated by default as identity
        (start with 1 maxvalue 999999999 minvalue 1 nocycle nocache noorder) primary key,
    id_hospital number references kabenyk_st.hospitals (id_hospital),
    surname varchar2(100) not null,
    name varchar2(100) not null,
    patronymic varchar2(100) not null,
    area number not null,
    id_qualification number references kabenyk_st.doctors_qualifications (id_doctors_qualifications),
    data_of_record_deletion date
);
create table kabenyk_st.gender(
    id_gender number generated by default as identity
        (start with 1 maxvalue 999999999 minvalue 1 nocycle nocache noorder) primary key,
    gender varchar2(100) not null
);
create table kabenyk_st.specializations(
    id_specialization number generated by default as identity
        (start with 1 maxvalue 999999999 minvalue 1 nocycle nocache noorder) primary key,
    specialization varchar2(100) not null,
    min_age number not null,
    max_age number not null,
    id_gender number references kabenyk_st.gender(id_gender),
    data_of_record_deletion date
);
create table kabenyk_st.doctors_specializations(
    id_doctor number,
    id_specialization number,
    primary key (id_doctor, id_specialization),
    foreign key (id_doctor) references kabenyk_st.doctors (id_doctor),
    foreign key (id_specialization) references kabenyk_st.specializations (id_specialization)
);
create table kabenyk_st.ticket_flags(
    id_ticket_flag number generated by default as identity
        (start with 1 maxvalue 999999999 minvalue 1 nocycle nocache noorder) primary key,
    flag varchar2(10) not null
);
create table kabenyk_st.tickets(
    id_ticket number generated by default as identity
        (start with 1 maxvalue 999999999 minvalue 1 nocycle nocache noorder) primary key,
    id_ticket_flag number references kabenyk_st.ticket_flags (id_ticket_flag),
    begin_time date not null,
    end_time date not null,
    id_doctor number references kabenyk_st.doctors (id_doctor),
    data_of_record_deletion date
);
create table kabenyk_st.accounts(
    id_account number generated by default as identity
        (start with 1 maxvalue 999999999 minvalue 1 nocycle nocache noorder) primary key,
    name varchar2(100) not null
);
create table kabenyk_st.documents(
    id_document number generated by default as identity
        (start with 1 maxvalue 999999999 minvalue 1 nocycle nocache noorder) primary key,
    name varchar2(16) not null
);
create table kabenyk_st.patients(
    id_patient number generated by default as identity
        (start with 1 maxvalue 999999999 minvalue 1 nocycle nocache noorder) primary key,
    surname varchar2(100) not null,
    name varchar2(100) not null,
    patronymic varchar2(100),
    date_of_birth date not null,
    id_gender number references kabenyk_st.gender (id_gender),
    phone number(11),
    area number not null,
    id_account number references kabenyk_st.accounts (id_account)
);
create table kabenyk_st.documents_numbers(
    id_document_number number generated by default as identity
        (start with 1 maxvalue 999999999 minvalue 1 nocycle nocache noorder) primary key,
    id_patient number references kabenyk_st.patients (id_patient),
    id_document number references kabenyk_st.documents (id_document),
    value number
);
create table kabenyk_st.journal_record_status(
    id_journal_record_status number generated by default as identity
        (start with 1 maxvalue 999999999 minvalue 1 nocycle nocache noorder) primary key,
    status varchar2(100) not null
);
create table kabenyk_st.patients_journals(
    id_journal number generated by default as identity
        (start with 1 maxvalue 999999999 minvalue 1 nocycle nocache noorder) primary key,
    id_journal_record_status number references kabenyk_st.journal_record_status (id_journal_record_status),
    day_time date not null,
    id_patient number references kabenyk_st.patients (id_patient),
    id_ticket number references kabenyk_st.tickets (id_ticket),
    data_of_record_deletion date
);

create table kabenyk_st.doctors_qualifications(
    id_doctors_qualifications number generated by default as identity
        (start with 1 maxvalue 999999999 minvalue 1 nocycle nocache noorder) primary key,
    id_doctor number references kabenyk_st.doctors (id_doctor),
    education varchar2(16) not null,
    qualification varchar2(16) not null,
    salary number not null,
    rating number
);
create table kabenyk_st.feedbacks(
    id_feedback number generated by default as identity
        (start with 1 maxvalue 999999999 minvalue 1 nocycle nocache noorder) primary key,
    id_doctor number references kabenyk_st.doctors (id_doctor),
    feedback varchar2(4000)
);
