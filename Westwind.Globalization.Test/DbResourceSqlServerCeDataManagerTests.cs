﻿using System;
using System.Collections;
using System.Collections.Generic;
using NUnit.Framework;
using Westwind.Utilities.Data;


namespace Westwind.Globalization.Test
{
    [TestFixture]
    public class DbResourceSqlServerCeDataManagerTests
    {

        private DbResourceSqlServerCeDataManager GetManager()
        {
            var manager = new DbResourceSqlServerCeDataManager();
            //manager.Configuration.ConnectionString = "SqlServerCeLocalizations";
            //manager.Configuration.ResourceTableName = "Localizations";
            return manager;
        }


        [Test]
        public void CreateTable()
        {
            var manager = GetManager();

            bool result = manager.CreateLocalizationTable();

            // no assertions as table can exist - to test explicitly remove the table
            if (result)
                Console.WriteLine("Table created.");
            else
                Console.WriteLine(manager.ErrorMessage);
        }

        [Test]
        public void GetAllResources()
        {
            var manager = GetManager();

            var items = manager.GetAllResources(false);
            Assert.IsNotNull(items);
            Assert.IsTrue(items.Count > 0);

            ShowResources(items);    
        }

        [Test]
        public void GetResourceSet()
        {
            var manager = GetManager();

            var items = manager.GetResourceSet("de","Resources");
            Assert.IsNotNull(items);
            Assert.IsTrue(items.Count > 0);

            ShowResources(items);
        }

        [Test]
        public void GetResourceSetNormalizedForLocaleId()
        {
            var manager = GetManager();

            var items = manager.GetResourceSetNormalizedForLocaleId("de", "Resources");
            Assert.IsNotNull(items);
            Assert.IsTrue(items.Count > 0);

            ShowResources(items);
        }

        [Test]
        public void GetAllResourceIds()
        {
            var manager = GetManager();

            var items = manager.GetAllResourceIds("Resources");
            Assert.IsNotNull(items,manager.ErrorMessage);
            Assert.IsTrue(items.Count > 0);
        }


        [Test]
        public void GetAllResourceIdsForHtmlDisplay()
        {
            var manager = GetManager();
            var items = manager.GetAllResourceIdsForHtmlDisplay("Resources");

            Assert.IsNotNull(items);
            Assert.IsTrue(items.Count > 0);

            foreach (var item in items)
            {
                Console.WriteLine(item.Value + ": " + item.Text + " " + (item.Selected ? "* " : "") + (item.Attributes.Count > 0) );
            }
        }
        
        [Test]
        public void GetAllResourceSets()
        {
            var manager = GetManager();

            var items = manager.GetAllResourceSets(ResourceListingTypes.AllResources);
            Assert.IsNotNull(items);
            Assert.IsTrue(items.Count > 0);

            foreach (var item in items)
            {
                Console.WriteLine(item);
            }

            items = manager.GetAllResourceSets(ResourceListingTypes.LocalResourcesOnly);
            Assert.IsNotNull(items);            

            Console.WriteLine("--- Local ---");
            foreach (var item in items)
            {
                Console.WriteLine(item);
            }

            items = manager.GetAllResourceSets(ResourceListingTypes.GlobalResourcesOnly);
            Assert.IsNotNull(items);            

            Console.WriteLine("--- Global ---");
            foreach (var item in items)
            {
                Console.WriteLine(item);
            }
        }

        [Test]
        public void GetAllLocaleIds()
        {
            var manager = GetManager();

            var items = manager.GetAllLocaleIds("Resources");
            Assert.IsNotNull(items);
            Assert.IsTrue(items.Count > 0);

            foreach (var localeId in items)
            {
                Console.WriteLine(":" + localeId);
            }
            
        }

        [Test]
        public void GetAllResourcesForCulture()
        {
            var manager = GetManager();

            var items = manager.GetAllResourcesForCulture("Resources","de");
            Assert.IsNotNull(items);
            Assert.IsTrue(items.Count > 0);

            foreach (var localeId in items)
            {
                Console.WriteLine(":" + localeId);
            }
        }

        [Test]
        public void GetResourceString()
        {
            var manager = GetManager();

            var item = manager.GetResourceString("Today", "Resources", "de");

            Assert.IsNotNull(item);
            Assert.IsTrue(item == "Heute");
        }

        [Test]
        public void GetResourceItem()
        {
            var manager = GetManager();

            var item = manager.GetResourceItem("Today", "Resources", "de");

            Assert.IsNotNull(item);
            Assert.IsTrue(item.Value.ToString() == "Heute");
        }

        [Test]
        public void GetResourceObject()
        {
            var manager = GetManager();

            // this method allows retrieving non-string values as their
            // underlying type - demo data doesn't include any binary data.
            var item = manager.GetResourceObject("Today", "Resources", "de");

            Assert.IsNotNull(item);
            Assert.IsTrue(item.ToString() == "Heute");
        }

        [Test]
        public void GetResourceStrings()
        {
            var manager = GetManager();

            var items = manager.GetResourceStrings("Today", "Resources");

            Assert.IsNotNull(items);
            Assert.IsTrue(items.Count > 0);

            ShowResources(items);

        }


     




        private void ShowResources(IDictionary items)
        {
            foreach (DictionaryEntry resource in items)
            {
                Console.WriteLine(resource.Key + ": " + resource.Value);
            }
        }
        private void ShowResources(IEnumerable<ResourceItem> items)
        {
            foreach (var resource in items)
            {
                Console.WriteLine(resource.ResourceId + " - " + resource.LocaleId + ": " + resource.Value);
            }
        }
    }
}