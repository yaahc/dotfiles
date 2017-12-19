
case $1 in
    unit)
        make BUILD_SCQAD_CASES=1 BUILD_TYPE=debug TARGETDIR=obj/generic -j32 -C /local/scale-product runtest
        break
        ;;
    slowunit)
        make BUILD_SCQAD_CASES=1 BUILD_TYPE=debug TARGETDIR=obj/generic -C /local/scale-product runtest
        break
        ;;
    bear)
        bear make BUILD_SCQAD_CASES=1 BUILD_TYPE=debug TARGETDIR=obj/generic -j32 -C /local/scale-product
        break
        ;;
    slow)
        make BUILD_SCQAD_CASES=1 BUILD_TYPE=debug TARGETDIR=obj/generic -C /local/scale-product
        break
        ;;
    *)
        make BUILD_SCQAD_CASES=1 BUILD_TYPE=debug TARGETDIR=obj/generic -j32 -C /local/scale-product
        break
        ;;
esac
