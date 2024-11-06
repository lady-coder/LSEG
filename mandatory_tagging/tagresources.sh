#!/bin/sh

if $taglambda
then 

        echo "Adding tags to lambdas"
        #################################
        # Tag all lambdas with mnd tags #
        #################################
        alllambda=`aws lambda list-functions --region ${REGION} | jq -r .Functions[].FunctionName`
        for lambda in $alllambda
        do
            echo "Tag lambda $lambda.."
            keys=`aws lambda get-function --region ${REGION} --function-name $lambda | jq -r .Configuration.FunctionArn`
            echo $keys
            tags=`aws lambda tag-resource --region ${REGION} --resource $keys --tags "Tenant=${TENANT},Service=Infrastructure,mnd-applicationid=${application_id},mnd-applicationname=${application_name},
                mnd-owner=${owner}@lseg.com,mnd-supportgroup=tobeconfirmed,mnd-projectcode=${project_code},mnd-costcentre=${cost_centre},mnd-envtype=${envtype},mnd-envsubtype=${subtype},mnd-dataclassification=highlyrestricted,mnd-baseimagename=notapplicable"`
            echo "Tags added for $lambda"
        done
        #########################################
        #Additional tenant specific lambda tags #
        #########################################
        notification_lambda=`aws lambda list-functions --region ${REGION} | jq -r .Functions[].FunctionName | grep 'notification'`
        for i in $notification_lambda
        do
            echo "Tag lambda $i.."
            key=`aws lambda get-function --region ${REGION} --function-name $i | jq -r .Configuration.FunctionArn`
            echo $key
            tag=`aws lambda tag-resource --region ${REGION} --resource $key --tags "Tenant=${TENANT},Service=${NF},mnd-applicationid=${application_id},mnd-applicationname=${application_name},
                mnd-owner=${owner}@lseg.com,mnd-supportgroup=tobeconfirmed,mnd-projectcode=${project_code},mnd-costcentre=${cost_centre},mnd-envtype=${envtype},mnd-envsubtype=${subtype},mnd-dataclassification=highlyrestricted,mnd-baseimagename=notapplicable"`
            echo "Tags added for $i"
        done


        boxi_lambda=`aws lambda list-functions --region ${REGION} | jq -r .Functions[].FunctionName | grep 'boapi'`
        for bo in $boxi_lambda
        do
            echo "Tag lambda $bo.."
            bokey=`aws lambda get-function --region ${REGION} --function-name $bo | jq -r .Configuration.FunctionArn`
            echo $bokey
            tagbo=`aws lambda tag-resource --region ${REGION} --resource $bokey --tags "Tenant=BOXI,Service=BOXImnd-applicationid=${application_id},mnd-applicationname=${application_name},
                mnd-owner=${owner}@lseg.com,mnd-supportgroup=tobeconfirmed,mnd-projectcode=${project_code},mnd-costcentre=${cost_centre},mnd-envtype=${envtype},mnd-envsubtype=${subtype},mnd-dataclassification=highlyrestricted,mnd-baseimagename=notapplicable"` 
            echo "Tags added for $bo"
        done

fi

if $tags3
then

        echo "Adding tags to TENANT BUCKETS"
        declare -a buckets=("clm" "cds" "rrm" "dpg" "fxc" "gfs")

        ############################
        #Tag all buckets with mnd- #
        ############################
        alls3=`aws s3 ls | awk '{split($0,a," "); print a[3]}'`
        for s3 in $alls3
            do
                echo Tagging $s3
                aws s3api put-bucket-tagging --bucket $s3 --tagging "TagSet=[{Key=Tenant, Value="Concorde"},{Key=Service, Value="Infrastructure"},
                {Key=mnd-applicationid, Value=${application_id}},{Key=mnd-applicationname, Value=${application_name}},
                {Key=mnd-owner, Value="${owner}@lseg.com"},{Key=mnd-supportgroup, Value="tobeconfirmed"},
                {Key=mnd-projectcode, Value=${project_code}},{Key=mnd-costcentre, Value=${cost_centre}},
                {Key=mnd-envtype, Value=${envtype}},{Key=mnd-envsubtype, Value=${subtype}},
                {Key=mnd-dataclassification, Value="highlyrestricted"},{Key=mnd-baseimagename, Value="notapplicable"}]"
            done
        ################################
        # Tag tenant specific buckets  # 
        ################################ 
        for b in "${buckets[@]}"
        do
            buck=`aws s3 ls | grep $b | awk '{split($0,a," "); print a[3]}'`
            for iter in $buck
            do
                echo Tagging $iter
                aws s3api put-bucket-tagging --bucket $iter --tagging "TagSet=[{Key=Tenant, Value=$b},{Key=Service, Value=${NF}},
                {Key=mnd-applicationid, Value=${application_id}},{Key=mnd-applicationname, Value=${application_name}},
                {Key=mnd-owner, Value="${owner}@lseg.com"},{Key=mnd-supportgroup, Value="tobeconfirmed"},
                {Key=mnd-projectcode, Value=${project_code}},{Key=mnd-costcentre, Value=${cost_centre}},
                {Key=mnd-envtype, Value=${envtype}},{Key=mnd-envsubtype, Value=${subtype}},
                {Key=mnd-dataclassification, Value="highlyrestricted"},{Key=mnd-baseimagename, Value="notapplicable"}]"
            done
        done
fi