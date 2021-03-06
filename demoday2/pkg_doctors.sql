create or replace package kabenyk_st.pkg_doctors
as

    function all_doctors_by_hospital (
        p_id_hospital in number,
        p_area in number,
        out_result out integer
    )
    return kabenyk_st.t_arr_doctor;

    function is_doctor_marked_as_deleted (
        p_id_ticket in number,
        out_result out integer
    )
    return boolean;

    function get_doctor_by_id_doctor_speciality (
        p_id_doctor_speciality in number,
        out_result out integer
    )
    return kabenyk_st.t_doctor;

    function get_doctor_by_id (
        p_id_doctor in number,
        out_result out integer
    )
    return kabenyk_st.t_doctor;

    procedure merging_doctors_table (
        p_doctor_external in kabenyk_st.t_doctor_external,
        out_result out integer
    );

end pkg_doctors;

create or replace package body kabenyk_st.pkg_doctors
as
    function all_doctors_by_hospital (
        p_id_hospital in number,
        p_area in number,
        out_result out integer
    )
    return kabenyk_st.t_arr_doctor
    as
        v_arr_doctor kabenyk_st.t_arr_doctor := kabenyk_st.t_arr_doctor();
    begin
        select kabenyk_st.t_doctor(
            id_doctor => d.id_doctor,
            id_hospital => d.id_hospital,
            surname => d.surname,
            name => d.name,
            patronymic => d.patronymic,
            area => d.area,
            id_doctors_qualifications => d.id_doctors_qualifications,
            id_doctor_external => d.id_doctor_external
        )
        bulk collect into v_arr_doctor
        from kabenyk_st.doctors d
            join kabenyk_st.doctors_qualifications q
                on d.id_doctors_qualifications = q.id_doctors_qualifications
        where d.data_of_record_deletion is null and (
            p_id_hospital is null or (
            p_id_hospital is not null and
            d.id_hospital = p_id_hospital
            )
        )
        order by qualification,
            case
                when d.area = p_area then 0
                else 1
            end;
        out_result := kabenyk_st.pkg_code.c_ok;
        return v_arr_doctor;
    end;

    function is_doctor_marked_as_deleted (
        p_id_ticket in number,
        out_result out integer
    )
    return boolean
    as
        v_deletion_date date;

    begin
        select d.data_of_record_deletion into v_deletion_date
        from kabenyk_st.tickets t
            join kabenyk_st.doctor_specialty ds
                on t.id_doctor_specialization = ds.id_doctor_specialization
            join kabenyk_st.doctors d
                on ds.id_doctor = d.id_doctor
        where t.id_ticket = p_id_ticket;

        if v_deletion_date is not null then
            raise kabenyk_st.pkg_errors.e_doctor_deleted_exception;
        end if;
        out_result := kabenyk_st.pkg_code.c_ok;
        return false;
    end;

    function get_doctor_by_id_doctor_speciality (
        p_id_doctor_speciality number,
        out_result out integer
    )
    return kabenyk_st.t_doctor
    as
        v_doctor kabenyk_st.t_doctor;
    begin
        select kabenyk_st.t_doctor(
            id_doctor => d.id_doctor,
            id_hospital => d.id_hospital,
            surname => d.surname,
            name => d.name,
            patronymic => d.patronymic,
            area => d.area,
            id_doctors_qualifications => d.id_doctors_qualifications,
            id_doctor_external => null
        )
        into v_doctor
        from kabenyk_st.doctors d
            join kabenyk_st.doctor_specialty ds
                on d.id_doctor = ds.id_doctor
        where ds.id_doctor_specialization = p_id_doctor_speciality
            and d.data_of_record_deletion is null;

        out_result := kabenyk_st.pkg_code.c_ok;
        return v_doctor;
    exception
        when no_data_found then
            dbms_output.put_line ('Error. No data found');
            kabenyk_st.add_error_log(
                $$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2),
                '{"error":"' || sqlerrm
                ||'","id_doctor_speciality":"' || p_id_doctor_speciality
                ||'","backtrace":"' || dbms_utility.format_error_backtrace()
                ||'"}'
            );
            out_result := kabenyk_st.pkg_code.c_error;
        return null;
    end;

    function get_doctor_by_id (
        p_id_doctor number,
        out_result out integer
    )
    return kabenyk_st.t_doctor
    as
        v_doctor kabenyk_st.t_doctor;
    begin
        select kabenyk_st.t_doctor(
            id_doctor => d.id_doctor,
            id_hospital => d.id_hospital,
            surname => d.surname,
            name => d.name,
            patronymic => d.patronymic,
            area => d.area,
            id_doctors_qualifications => d.id_doctors_qualifications,
            id_doctor_external => null
        )
        into v_doctor
        from kabenyk_st.doctors d
        where d.id_doctor = p_id_doctor
            and d.data_of_record_deletion is null;

        out_result := kabenyk_st.pkg_code.c_ok;
        return v_doctor;
    exception
        when no_data_found then
            dbms_output.put_line ('Error. No data found');
            kabenyk_st.add_error_log(
                $$plsql_unit_owner||'.'||$$plsql_unit||'.'||utl_call_stack.subprogram(1)(2),
                '{"error":"' || sqlerrm
                ||'","id_doctor":"' || p_id_doctor
                ||'","backtrace":"' || dbms_utility.format_error_backtrace()
                ||'"}'
            );
            out_result := kabenyk_st.pkg_code.c_error;
        return null;
    end;

    procedure merging_doctors_table (
        p_doctor_external kabenyk_st.t_doctor_external,
        out_result out integer
    )
    as
        v_id_hospital number;

    begin

        merge into kabenyk_st.doctors d
        using (
            select
                p_doctor_external.surname,
                p_doctor_external.name,
                p_doctor_external.patronymic,
                p_doctor_external.id_doctor_external
            from dual)
        on (d.id_doctor_external = p_doctor_external.id_doctor_external)
        when matched then update
        set d.id_hospital = v_id_hospital,
            d.surname = p_doctor_external.surname,
            d.name = p_doctor_external.name,
            d.patronymic = p_doctor_external.patronymic
        when not matched then insert (id_hospital, surname, name, patronymic, id_doctor_external)
        values (
            v_id_hospital, p_doctor_external.surname, p_doctor_external.name,
            p_doctor_external.patronymic, p_doctor_external.id_doctor_external
        );

        inserting_doctor_specialty_table (
            p_doctor_external => p_doctor_external
        );
        commit;

        out_result := kabenyk_st.pkg_code.c_ok;
    end;

end pkg_doctors;


