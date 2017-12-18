
case $1 in
    unit)
        make BUILD_SCQAD_CASES=1 BUILD_TYPE=debug TARGETDIR=obj/generic -j32 -C /local/scale-product runtest | tee build.txt 2>&1
        break
        ;;
    bear)
        alias bearbuild='bear make BUILD_SCQAD_CASES=1 BUILD_TYPE=debug TARGETDIR=obj/generic -j32 -C /local/scale-product | tee build.txt 2>&1'
        break
        ;;
    *)
        make BUILD_SCQAD_CASES=1 BUILD_TYPE=debug TARGETDIR=obj/generic -j32 -C /local/scale-product | tee build.txt 2>&1
        break
        ;;
esac
