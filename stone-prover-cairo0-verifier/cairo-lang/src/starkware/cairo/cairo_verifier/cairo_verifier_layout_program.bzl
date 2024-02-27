load("//src/starkware/cairo/lang:cairo_rules.bzl", "cairo_binary")

def cairo_verifier_program(layout_name):
    """
    Generates a Cairo verifier program with the given layout.
    Returns the program name and the compiled program name.
    """

    program_name = "cairo_verifier_program_%s" % layout_name
    compiled_program_name = "cairo_verifier_compiled_%s.json" % layout_name
    main_cairo_file = (
        "//src/starkware/cairo/cairo_verifier/layouts/%s:cairo_verifier.cairo" % layout_name
    )

    cairo_binary(
        name = program_name,
        srcs = [
            main_cairo_file,
            "//src/starkware/cairo/stark_verifier/air/layouts/%s:autogenerated.cairo" % layout_name,
            "//src/starkware/cairo/stark_verifier/air/layouts/%s:composition.cairo" % layout_name,
            "//src/starkware/cairo/stark_verifier/air/layouts/%s:global_values.cairo" % layout_name,
            "//src/starkware/cairo/stark_verifier/air/layouts/%s:periodic_columns.cairo" % layout_name,
            "//src/starkware/cairo/stark_verifier/air/layouts/%s:public_verify.cairo" % layout_name,
            "//src/starkware/cairo/stark_verifier/air/layouts/%s:verify.cairo" % layout_name,
        ],
        cairoopts = [
            "--no_debug_info",
            "--proof_mode",
        ],
        compiled_program_name = compiled_program_name,
        main = main_cairo_file,
        deps = [":cairo_verifier_program_lib"],
        tags = ["external_cairo", "external_cairo-docs"],
    )

    return struct(program_name = program_name, compiled_program_name = compiled_program_name)
